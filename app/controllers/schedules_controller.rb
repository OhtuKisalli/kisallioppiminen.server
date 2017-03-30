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
