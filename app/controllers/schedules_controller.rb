class SchedulesController < ApplicationController
  before_action :check_signed_in
  before_action :check_admin, only: [:index]

  # GET /schedules
  def index
    @schedules = ScheduleService.all_schedules
  end

  # Teacher - add schedule to schedules list
  # post '/courses/:id/schedules/new' 
  def new_schedule
    if not TeachingService.has_rights?(current_user.id, params[:id])
      render :json => {"error" => "Et ole kyseisen kurssin vastuuhenkilö."}, status: 401
    elsif not params[:name] or params[:name].blank?
      render :json => {"error" => "Tavoitteella täytyy olla nimi."}, status: 422
    elsif ScheduleService.name_reserved?(params[:id], params[:name])
      render :json => {"error" => "Kahdella tavoitteella ei voi olla samaa nimeä."}, status: 422
    elsif ScheduleService.add_new_schedule(params[:id], params[:name])
      render :json => {"message" => "Tavoite tallennettu tietokantaan."}, status: 200
    else 
      render :json => {"error" => "Tavoitetta ei voida tallentaa tietokantaan."}, status: 422
    end
  end
  
  # Teacher - delete schedule
  # delete '/courses/:cid/schedules/:did' 
  def delete_deadline
  
  end
  
  # Teacher - Add / update exercises of schedules created
  # post '/courses/:id/schedules/'
  def update_exercises
  
  end


end
