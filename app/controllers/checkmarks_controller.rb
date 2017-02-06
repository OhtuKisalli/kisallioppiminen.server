class CheckmarksController < ApplicationController
  before_action :set_checkmark, only: [:destroy]

  protect_from_forgery unless: -> { request.format.json? }

  # GET /checkmarks
  def index
    @checkmarks = Checkmark.all
  end
  
  # POST /checkmarks
  def mark
    @coursekey = params[:coursekey]
    @html_id = params[:html_id]
    @user_id = params[:user_id]
    @course = Course.find_by(coursekey: @coursekey)
    @exercise = Exercise.find_by(course_id: @course.id, html_id: @html_id)
    @checkmark = Checkmark.find_by(exercise_id: @exercise.id, user_id: @user_id)
    if @checkmark.nil?
      @checkmark = Checkmark.new(user_id: @user_id, exercise_id: @exercise.id)
    end
    @checkmark.status = params[:status]
    respond_to do |format|
      if @checkmark.save 
        format.json { render json: @checkmark, status: :ok }
      else
        format.json { render json: @checkmark, status: :unprocessable_entity }
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
