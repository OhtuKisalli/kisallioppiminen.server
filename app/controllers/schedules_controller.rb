class SchedulesController < ApplicationController

  # GET /schedules
  def index
    @schedules = Schedule.all
  end


end
