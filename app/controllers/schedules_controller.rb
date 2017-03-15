class SchedulesController < ApplicationController

  # GET /schedules
  def index
    @schedules = ScheduleService.all_schedules
  end


end
