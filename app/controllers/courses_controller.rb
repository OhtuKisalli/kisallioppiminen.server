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
  
  #vanha - ilman current_user
  def sboard
    @course = Course.where(id: params[:id]).first
    if @course
      b = Scoreboard.new(@course.id)
      render :json => b.board, :except => [:id]
    else
      render :json => {}
    end
  end
  
  #Scoreboards for teacher (current_user)
  #todo refactor
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
  
  #Scoreboard for teacher (current_user)
  #todo refactor
  def scoreboard
    if not user_signed_in? or current_user.courses_to_teach.empty?
      render :json => {}
    else  
      @course = current_user.courses_to_teach.where(id: params[:id]).first
      if @course
        b = Scoreboard.new(@course.id)
        render :json => b.board, :except => [:id]
      else
        render :json => {}
      end
    end 
  end
  
  #Teacher – I can see a listing of my courses
  def mycourses_teacher
    if not user_signed_in? or current_user.courses_to_teach.empty?
      render :json => {}
    else
      @courses = current_user.courses_to_teach
      result = {}
      @courses.each do |c|
        courseinfo = {}
        courseinfo["coursename"] = c.name
        courseinfo["html_id"] = c.html_id
        courseinfo["startdate"] = c.startdate
        courseinfo["enddate"] = c.enddate
        result[c.coursekey] = courseinfo
      end
      render :json => result
    end
  end
  
  #Teacher – I can create coursekeys for students to join my course
  def newcourse
    @course = Course.new(course_params)
    if not user_signed_in?
        render :json => {"msg" => "user not logged in"}
    elsif not Course.where(coursekey: @course.coursekey).empty?
        render :json => {"msg" => "coursekey already in use"}
    elsif @course.save
        Teaching.create(user_id: current_user.id, course_id: @course.id)
        if params[:exercises]
          exercises = params[:exercises]
          exercises.each do |key, value|
            Exercise.create(html_id: value, course_id: @course.id)  
          end
          render :json => {"msg" => "created"}, status: 200        
        else
          render :json => {"msg" => "created without exercises"}
        end
    else
        render :json => {"msg" => "not ok"}, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:html_id, :coursekey, :name, :startdate, :enddate, :exercises)
    end
end
