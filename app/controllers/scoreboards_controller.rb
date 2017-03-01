class ScoreboardsController < ApplicationController

  protect_from_forgery unless: -> { request.format.json? }

  # Scoreboard for student
  # GET '/students/:sid/courses/:cid/scoreboard'
  # params: sid (User.id), cid (Course.id)
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
  
  # Scoreboards for student
  # - only courses that are not archived
  # get '/students/:id/scoreboards'
  # params: id (User.id)
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
  
  # Scoreboard for teacher
  # get '/teachers/:id/scoreboards'
  # return JSON
  def scoreboard
    if not user_signed_in?
      render :json => {"error" => "Sinun täytyy ensin kirjautua sisään."}, status: 401
    elsif current_user.courses_to_teach.empty?
      render :json => {"error" => "Et ole opettaja."}, status: 401
    else
      @course = current_user.courses_to_teach.where(id: params[:id]).first
      if @course
        b = Scoreboard.newboard(@course.id)
        render :json => b, :except => [:id], status: 200
      else
        render :json => {"error" => "Et ole kurssin opettaja."}, status: 401
      end
    end 
  end
  
  # Scoreboards for teacher
  # get '/courses/:id/scoreboard'
  # returns array of JSONs
  def scoreboards
    if not user_signed_in?
      render :json => {"error" => "Sinun täytyy ensin kirjautua sisään."}, status: 401
    elsif current_user.courses_to_teach.empty?
      render :json => {"error" => "Et ole opettaja."}, status: 401
    else
      @courses = current_user.courses_to_teach
      sb = []
      @courses.each do |c|
        sb << Scoreboard.newboard(c.id) 
      end
      render :json => sb, status: 200
    end 
  end

  private
    def make_student_scoreboard(cid, sid)
      checkmarks = Checkmark.student_checkmarks(cid, sid)
      course = Course.find(cid)
      scoreboard = course.courseinfo
      scoreboard["exercises"] = checkmarks
      return scoreboard
    end

end
