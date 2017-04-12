class SchedulesController < ApplicationController
  before_action :check_signed_in
  before_action :check_admin, only: [:index]

  # GET /schedules
  def index
    @schedules = ScheduleService.all_schedules
  end

  # Teacher - add schedule to schedules list
  # post '/courses/:id/schedules/new'
  # params: id (Course.id), name (string), color (integer)
  # TODO returns GET
  def new_schedule
    color = params[:color]
    if not TeachingService.has_rights?(current_user.id, params[:id])
      render :json => {"error" => "Et ole kyseisen kurssin vastuuhenkilö."}, status: 401
    elsif not color or color.blank? or color.to_i < 1
      render :json => {"error" => "Parametri color virheellinen."}, status: 422
    elsif not params[:name] or params[:name].blank?
      render :json => {"error" => "Tavoitteella täytyy olla nimi."}, status: 422
    elsif ScheduleService.name_reserved?(params[:id], params[:name])
      render :json => {"error" => "Kahdella tavoitteella ei voi olla samaa nimeä."}, status: 422
    elsif ScheduleService.add_new_schedule(params[:id], params[:name], color.to_i)
      render :json => ScheduleService.course_schedules(params[:id]), status: 200
    else 
      render :json => {"error" => "Tavoitetta ei voida tallentaa tietokantaan."}, status: 422
    end
  end
  
  # Teacher - delete schedule
  # delete '/courses/:cid/schedules/:did'
  # params Course.id, Schedule.id
  # TODO returns GET
  def delete_schedule
    cid = params[:cid]
    did = params[:did]
    if not TeachingService.has_rights?(current_user.id, cid)
      render :json => {"error" => "Et ole kyseisen kurssin vastuuhenkilö."}, status: 401
    elsif not ScheduleService.schedule_on_course?(cid, did)
      render :json => {"error" => "Kyseinen tavoite ei ole kurssilla."}, status: 401
    else
      ScheduleService.delete_schedule(did)
      render :json => ScheduleService.course_schedules(params[:id]), status: 200
    end
  end
  
  # Teacher - Add / update exercises of schedules created
  # post '/courses/:id/schedules/'
  # # schedules: {
  # "1" : {"ex_html_id1" : true, "ex_html_id2" : false},
  # "2" : { },
  # "3" : {"ex_html_id3" : false}}
  def update_exercises
    if not TeachingService.has_rights?(current_user.id, params[:id])
      render :json => {"error" => "Et ole kyseisen kurssin vastuuhenkilö."}, status: 401
    elsif not params[:schedules]
      render :json => {"error" => "Parametri schedules on virheellinen."}, status: 422
    elsif ScheduleService.update_schedule_exercises(params[:id], params[:schedules])
      render :json => ScheduleService.course_schedules(params[:id]), status: 200
    else
      render :json => {"error" => "Tavoitteita ei voitu tallentaa tietokantaan."}, status: 422
    end
  end
  
  # User - get schedules
  # get '/courses/:id/schedules/'
  # returns [{"id" : 1,"name" : "eka aikataulu","color": 1, "exercises":["ex_html_id1", "ex_html_id2"]},
  # {"id" : 2,"name" : "toka aikataulu","color": 2,"exercises":[]}]
  def get_schedules
    if not (TeachingService.teacher_on_course?(current_user.id, params[:id]) or AttendanceService.user_on_course?(current_user.id, params[:id]))
      render :json => {"error" => "Et ole kyseisen kurssin oppilas tai opettaja."}, status: 401  
    else
      render :json => ScheduleService.course_schedules(params[:id]), status: 200
    end  
  end
  

  
end
