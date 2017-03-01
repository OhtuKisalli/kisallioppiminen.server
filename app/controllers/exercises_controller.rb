class ExercisesController < ApplicationController
  before_action :set_exercise, only: [:show]
  
  protect_from_forgery unless: -> { request.format.json? }

  # GET /exercises
  def index
    @courses = Course.all
  end

  # GET /exercises/1
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exercise
      @exercise = Exercise.find(params[:id])
    end

end
