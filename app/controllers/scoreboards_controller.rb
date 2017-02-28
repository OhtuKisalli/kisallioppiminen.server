class ScoreboardsController < ApplicationController

  protect_from_forgery unless: -> { request.format.json? }

  def student_scoreboard
    sid = params[:sid]
    cid = params[:cid]
    if not user_signed_in?
      render :json => {"error" => "Sinun täytyy ensin kirjautua sisään."}, status: 401
    elsif sid.to_i != current_user.id
      render :json => {"error" => "Voit tarkastella vain omaa scoreboardiasi."}, status: 401
    elsif Attendance.where(user_id: sid, course_id: cid).empty?
      render :json => {"error" => "Et ole liittynyt kyseiselle kurssille."}, status: 422
    else
      scoreboard = make_student_scoreboard(cid, sid)
      render :json => scoreboard, status: 200
    end
  end
  
  # returns only courses that are not archived
  def student_scoreboards
    sid = params[:id]
    if not user_signed_in?
      render :json => {"error" => "Sinun täytyy ensin kirjautua sisään."}, status: 401
    elsif sid.to_i != current_user.id
      render :json => {"error" => "Voit tarkastella vain omia scoreboardejasi."}, status: 401
    else
      courses = current_user.courses
      sb = []
      courses.each do |c|
        if not Attendance.where(user_id: sid, course_id: c.id).first.archived
          sb << make_student_scoreboard(c.id, sid)
        end
      end
      render :json => sb, status: 200
    end
  end

  def make_student_scoreboard(cid, sid)
    checkmarks = Checkmark.student_checkmarks(cid, sid)
    course = Course.find(cid)
    scoreboard = {}
    scoreboard["name"] = course.name
    scoreboard["coursekey"] = course.coursekey
    scoreboard["html_id"] = course.html_id
    scoreboard["startdate"] = course.startdate
    scoreboard["enddate"] = course.enddate
    scoreboard["exercises"] = checkmarks
    return scoreboard
  end

end
