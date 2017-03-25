class CheckmarksController < ApplicationController
  before_action :check_signed_in
  before_action :check_admin, only: [:index]

  protect_from_forgery unless: -> { request.format.json? }

  # Backend
  # /checkmarks
  def index
    @count = CheckmarkService.all_checkmarks_count
  end

  # Student - new/update checkmark
  # POST '/checkmarks'
  # params: html_id (Course), coursekey, status
  def mark
    course = CourseService.find_by_coursekey(params[:coursekey])
    if course.nil?
      render :json => {"error" => "Kurssia ei löydy tietokannasta."}, status: 403
    elsif not AttendanceService.user_on_course?(current_user.id, course.id)
      render :json => {"error" => "Sinun täytyy ensin liittyä kurssille."}, status: 422
    elsif not CourseService.course_has_exercise?(course, params[:html_id])
      render :json => {"error" => "Tehtävää ei löydy tietokannasta."}, status: 403
    else
      html_id = params[:html_id]
      status = params[:status]
      if CheckmarkService.save_student_checkmark(current_user.id, course.id, html_id, status)
        render :json => {"message" => "Merkintä tallennettu."}, status: 201  
      else
        render :json => {"error" => "Merkintää ei voitu tallentaa."}, status: 422
      end
    end
  end
  
  # Student – I can see from an exercise if I have done it
  # - checkmarks for one course
  # - for student or teacher of the course
  # GET '/students/:sid/courses/:cid/checkmarks'
  # params: sid (User.id), cid (Course.id)
  def student_checkmarks
    sid = params[:sid]
    cid = params[:cid]
    if sid.to_i != current_user.id and not TeachingService.teacher_on_course?(current_user.id, cid)
      render :json => {"error" => "Voit tarkastella vain omia tai oppilaidesi merkintöjä."}, status: 401
    elsif not AttendanceService.user_on_course?(sid, cid)
      render :json => {"error" => "Käyttäjä ei ole rekisteröitynyt kurssille."}, status: 422
    else
      result = CourseService.student_checkmarks_course_info(sid, cid)
      result["exercises"] = CheckmarkService.student_checkmarks(cid, sid)
      render :json => result, status: 200
    end
  end
    
end
