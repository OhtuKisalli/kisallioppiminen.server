class AttendancesController < ApplicationController
  
  protect_from_forgery unless: -> { request.format.json? }

  # Backend 
  # /attendances
  def index
    @attendances = Attendance.all
  end
  
  # Student – I can join a specific course using a coursekeys
  # POST '/courses/join'
  # params: coursekey
  def newstudent
    @course = Course.where(coursekey: params[:coursekey]).first
    if not user_signed_in?
      render :json => {"error" => "Sinun täytyy ensin kirjautua sisään."}, status: 401
    elsif @course
      if Attendance.where(user_id: current_user.id, course_id: @course.id).any?
        render :json => {"error" => "Olet jo liittynyt kyseiselle kurssille."}, status: 403  
      else
        Attendance.create(user_id: current_user.id, course_id: @course.id)
        @courses = current_user.courses
        kurssit = {}
        @courses.each do |c|
          courseinfo = {}
          courseinfo["coursename"] = c.name
          courseinfo["html_id"] = c.html_id
          courseinfo["startdate"] = c.startdate
          courseinfo["enddate"] = c.enddate
          kurssit[c.coursekey] = courseinfo
        end
        render :json => {"message" => "Ilmoittautuminen tallennettu.", "courses" => kurssit}, status: 200
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
    if not user_signed_in?
      render :json => {"error" => "Sinun täytyy ensin kirjautua sisään."}, status: 401
    elsif sid.to_i != current_user.id
      render :json => {"error" => "Voit muuttaa vain omien kurssiesi asetuksia."}, status: 401
    elsif Attendance.where(user_id: sid, course_id: cid).empty?
      render :json => {"error" => "Et ole opiskelijana kyseisellä kurssilla."}, status: 403
    elsif params[:archived] == "true" or params[:archived] == "false"
      a = Attendance.where(user_id: sid, course_id: cid).first    
      if params[:archived] == "false"
        a.archived = false
        a.save
        render :json => {"message" => "Kurssi palautettu arkistosta."}, status: 200
      else
        a.archived = true
        a.save  
        render :json => {"message" => "Kurssi arkistoitu."}, status: 200
      end
    else 
      render :json => {"error" => "Arkistointitiedon muuttaminen ei onnistunut."}, status: 422
    end
  end
  
end

