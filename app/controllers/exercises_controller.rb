class ExercisesController < ApplicationController

  before_action :check_admin, only: [:index, :show]
  
  protect_from_forgery unless: -> { request.format.json? }

  # GET /exercises
  def index
    @courses = CourseService.all_courses
  end

  # GET /exercises/1
  def show
    @exercise = ExerciseService.exercise_by_id(params[:id])
  end

end
