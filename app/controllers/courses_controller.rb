class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy]

  protect_from_forgery unless: -> { request.format.json? }

  # GET /courses
  # GET /courses.json
  def index
    @courses = Course.all
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(course_params)

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course.destroy
    respond_to do |format|
      format.html { redirect_to courses_url, notice: 'Course was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET all checkmarks for this course
  def get_checkmarks
    render :json => '{"maa1":{"john":{"teht1":"green","teht2":"red","teht3":"grey","teht4":"grey","teht5":"grey","teht6":"green","teht7":"red","teht8":"grey","teht9":"grey","teht10":"grey"},"pekka":{"teht1":"red","teht2":"red","teht3":"grey","teht4":"grey","teht5":"grey","teht6":"green","teht7":"red","teht8":"grey","teht9":"grey","teht10":"grey"}}}'
  end
  
  #todo refactor with scoreboards
  def scoreboard
    @course = Course.where(id: params[:id]).first
    if @course
      b = Scoreboard.new(@course.id)
      render :json => b.board, :except => [:id]
    else
      render :json => {}
    end
  end
  
  #Scoreboards for teacher (current_user)
  def scoreboards
    if not user_signed_in? or current_user.courses_to_teach.empty?
      render :json => {}
    else  
      @courses = current_user.courses_to_teach
      s = {}
      @courses.each do |c|
        b = Scoreboard.new(c.id)
        s[c.coursekey] = b.board  
      end
      render :json => s
    end 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:html_id, :coursekey, :name)
    end
end
