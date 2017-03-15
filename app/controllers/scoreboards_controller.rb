class ScoreboardsController < ApplicationController
  before_action :check_signed_in
  protect_from_forgery unless: -> { request.format.json? }

  # Scoreboard for student
  # GET '/students/:sid/courses/:cid/scoreboard'
  # params: sid (User.id), cid (Course.id)
  def student_scoreboard
    sid = params[:sid]
    cid = params[:cid]
    if sid.to_i != current_user.id
      render :json => {"error" => "Voit tarkastella vain omaa scoreboardiasi."}, status: 401
    elsif not AttendanceService.user_on_course?(sid, cid)
      render :json => {"error" => "Et ole liittynyt kyseiselle kurssille."}, status: 422
    else
      scoreboard = ScoreboardService.build_student_scoreboard(cid, sid)
      render :json => scoreboard, status: 200
    end
  end
  
  # Scoreboards for student
  # - only courses that are not archived
  # get '/students/:id/scoreboards'
  # params: id (User.id)
  def student_scoreboards
    sid = params[:id]
    if sid.to_i != current_user.id
      render :json => {"error" => "Voit tarkastella vain omia scoreboardejasi."}, status: 401
    else
      sbs = ScoreboardService.build_student_scoreboards(sid)
      render :json => sbs, status: 200
    end
  end
  
  # Scoreboard for teacher
  # get '/courses/:id/scoreboard'
  # return JSON
  def scoreboard
    sid = current_user.id
    if not TeachingService.is_teacher?(sid)
      render :json => {"error" => "Et ole opettaja."}, status: 401
    elsif TeachingService.teacher_on_course?(sid, params[:id])
      sboard = ScoreboardService.build_scoreboard(params[:id])
      render :json => sboard, status: 200
    else
      render :json => {"error" => "Et ole kurssin opettaja."}, status: 401
    end 
  end
  
  # Scoreboards for teacher
  # get '/teachers/:id/scoreboards'
  # returns array of JSONs
  def scoreboards
    sid = current_user.id
    if not TeachingService.is_teacher?(sid)
      render :json => {"error" => "Et ole opettaja."}, status: 401
    else
      sbs = ScoreboardService.build_scoreboards(sid)
      render :json => sbs, status: 200
    end 
  end
  

end
