class CheckmarksController < ApplicationController
  before_action :check_signed_in, except: [:index]

  protect_from_forgery unless: -> { request.format.json? }

  # Backend
  # /checkmarks
  def index
    @count = Checkmark.all.count
  end

  # Student - new/update checkmark
  # POST '/checkmarks'
  # params: html_id (Course), coursekey, status
  def mark
    @course = Course.find_by(coursekey: params[:coursekey])
    if @course.nil?
      render :json => {"error" => "Kurssia ei löydy tietokannasta."}, status: 403
    elsif Attendance.where(user_id: current_user.id, course_id: @course.id).empty?
      render :json => {"error" => "Sinun täytyy ensin liittyä kurssille."}, status: 422
    elsif @course.exercises.where(html_id: params[:html_id]).empty?
      render :json => {"error" => "Tehtävää ei löydy tietokannasta."}, status: 403
    else
      html_id = params[:html_id]
      @exercise = Exercise.find_by(course_id: @course.id, html_id: html_id)
      @checkmark = Checkmark.find_by(exercise_id: @exercise.id, user_id: current_user.id)
      if @checkmark.nil?
        @checkmark = Checkmark.new(user_id: current_user.id, exercise_id: @exercise.id)
      end
      @checkmark.status = params[:status]
      if @checkmark.save 
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
    if sid.to_i != current_user.id and Teaching.where(user_id: current_user.id, course_id: cid).empty?
      render :json => {"error" => "Voit tarkastella vain omia tai oppilaidesi merkintöjä."}, status: 401
    elsif Attendance.where(user_id: sid, course_id: cid).empty?
      render :json => {"error" => "Käyttäjä ei ole rekisteröitynyt kurssille."}, status: 422
    else
      course = Course.find(cid)
      result = {}
      result["html_id"] = course.html_id
      result["coursekey"] = course.coursekey
      result["archived"] = Attendance.where(user_id: sid, course_id: cid).first.archived
      checkmarks = CheckmarkService.student_checkmarks(cid, sid)
      result["exercises"] = checkmarks
      render :json => result, status: 200
    end
  end
    
end
