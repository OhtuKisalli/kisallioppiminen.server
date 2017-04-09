class AttendancesController < ApplicationController
  before_action :check_signed_in
  before_action :check_admin, only: [:index]
  
  protect_from_forgery unless: -> { request.format.json? }

  # Backend 
  # /attendances
  def index
    @attendances = AttendanceService.all_attendances
  end
  
  # Student – I can join a specific course using a coursekeys
  # POST '/courses/join'
  # params: coursekey
  def newstudent
    course = CourseService.find_by_coursekey(params[:coursekey])
    if course
      if AttendanceService.user_on_course?(current_user.id, course.id)
        render :json => {"error" => "Olet jo liittynyt kyseiselle kurssille."}, status: 403  
      elsif TeachingService.teacher_on_course?(current_user.id, course.id)
        render :json => {"error" => "Olet kurssin opettaja, et voi liittyä oppilaaksi."}, status: 403
      else
        courses = AttendanceService.add_new_course_to_user(current_user.id, course.id)
        render :json => {"message" => "Ilmoittautuminen tallennettu.", "courses" => courses}, status: 200
      end
    else
      render :json => {"error" => "Kurssia ei löydy tietokannasta."}, status: 403
    end
  end
  
  # Archive/recover course
  # POST 'students/:sid/courses/:cid/toggle_archived'
  # params: sid (User.id), cid (Course.id), archived ("true"/"false")
  def toggle_archived
    sid = params[:sid]
    cid = params[:cid]
    if sid.to_i != current_user.id
      render :json => {"error" => "Voit muuttaa vain omien kurssiesi asetuksia."}, status: 401
    elsif not AttendanceService.user_on_course?(sid, cid)
      render :json => {"error" => "Et ole opiskelijana kyseisellä kurssilla."}, status: 403
    elsif params[:archived] == "true" or params[:archived] == "false"
      AttendanceService.change_archived_status(sid, cid, params[:archived])
      if params[:archived] == "false"
        render :json => {"message" => "Kurssi palautettu arkistosta."}, status: 200
      else
        render :json => {"message" => "Kurssi arkistoitu."}, status: 200
      end
    else 
      render :json => {"error" => "Arkistointitiedon muuttaminen ei onnistunut."}, status: 422
    end
  end
  
end

