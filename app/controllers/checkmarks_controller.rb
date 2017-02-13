class CheckmarksController < ApplicationController
  before_action :set_checkmark, only: [:destroy]

  protect_from_forgery unless: -> { request.format.json? }

  # GET /checkmarks
  def index
    @checkmarks = Checkmark.all
  end
  
  # POST /checkmarks
  def mark
    @course = Course.find_by(coursekey: params[:coursekey])
    if not user_signed_in?
      render :json => {"error" => "User must be signed in"}, status: 401
    elsif @course.nil?
      render :json => {"error" => "Course not found"}, status: 403
    elsif Attendance.where(user_id: current_user.id, course_id: @course.id).empty?
      render :json => {"error" => "Et ole liittynyt kurssille"}, status: 422
    elsif @course.exercises.where(html_id: params[:html_id]).empty?
      render :json => {"error" => "Exercise not found"}, status: 403
    else
      html_id = params[:html_id]
      @exercise = Exercise.find_by(course_id: @course.id, html_id: html_id)
      @checkmark = Checkmark.find_by(exercise_id: @exercise.id, user_id: current_user.id)
      if @checkmark.nil?
        @checkmark = Checkmark.new(user_id: current_user.id, exercise_id: @exercise.id)
      end
      @checkmark.status = params[:status]
      if @checkmark.save 
        render :json => {"message" => "Checkmark saved"}, status: 201  
      else
        render :json => {"error" => "Checkmark not saved"}, status: 422
      end
    end
  end
  
  #voi poistaa kun frontend hakee opiskelijan checkmarkit GET:llä
  def vanha
    @user_id = params[:user_id]
    @coursekey = params[:coursekey]
    @course = Course.find_by(coursekey: @coursekey)
    @exercises = Exercise.where(course_id: @course.id).ids
    @cmarks = Checkmark.joins(:exercise).where(user_id: @user_id, exercise_id: @exercises).select("user_id","exercises.html_id","status")
    respond_to do |format|
      format.json { render json: @cmarks, status: :ok }
    end
  end
  
  #opiskelijan yhden kurssin checkmarkit GET /student/:sid/courses/:cid/checkmarks'
  def student_checkmarks
    s_checkmarks(params)
  end
  
  def s_checkmarks(params)
    user_id = params[:sid]
    @exercises = Exercise.where(course_id: params[:cid]).ids
    @cmarks = Checkmark.joins(:exercise).where(user_id: user_id, exercise_id: @exercises).select("exercises.html_id","status")
    checkmarks = {}
    @cmarks.each do |c|
      checkmarks[c.html_id] = c.status
    end  
    render :json => checkmarks
  end
  
  #opiskelijan yhden kurssin checkmarkit GET /courses/:cid/mycheckmarks'
  def mycheckmarks
    if not user_signed_in?
      render :json => {}
    else  
      s_checkmarks(:sid => current_user.id, :cid => params[:cid])
    end
  end

  # DELETE /checkmarks/1
  # DELETE /checkmarks/1.json
  def destroy
    @checkmark.destroy
    respond_to do |format|
      format.html { redirect_to checkmarks_url, notice: 'Checkmark was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_checkmark
      @checkmark = Checkmark.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def checkmark_params
      params.permit(:user_id, :html_id, :coursekey, :status)
    end
end
