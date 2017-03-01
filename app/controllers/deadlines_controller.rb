class DeadlinesController < ApplicationController
  
  # GET /deadlines
  def index
    @deadlines = Deadline.all
  end


end
