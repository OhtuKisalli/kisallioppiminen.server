class SchedulesController < ApplicationController

  before_action :check_admin, only: [:index]

  # GET /schedules
  def index
    @schedules = ScheduleService.all_schedules
  end


end
