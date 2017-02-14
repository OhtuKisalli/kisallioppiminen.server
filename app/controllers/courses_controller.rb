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
  
  #Scoreboards for teacher (current_user)
  def scoreboards
    if not user_signed_in?
      render :json => {"error" => "Sinun täytyy ensin kirjautua sisään."}, status: 401
    elsif current_user.courses_to_teach.empty?
      render :json => {"error" => "Et ole opettaja."}, status: 401
    else
      @courses = current_user.courses_to_teach
      sb = {}
      @courses.each do |c|
        b = Scoreboard.new(c.id)
        sb[c.coursekey] = b.board  
      end
      render :json => sb, status: 200
    end 
  end
  
  #Scoreboard for teacher (current_user)
  def scoreboard
    if not user_signed_in?
      render :json => {"error" => "Sinun täytyy ensin kirjautua sisään."}, status: 401
    elsif current_user.courses_to_teach.empty?
      render :json => {"error" => "Et ole opettaja."}, status: 401
    else
      @course = current_user.courses_to_teach.where(id: params[:id]).first
      if @course
        b = Scoreboard.new(@course.id)
        render :json => b.board, :except => [:id], status: 200
      else
        render :json => {"error" => "Et ole kurssin opettaja."}, status: 401
      end
    end 
  end
  
  #Teacher – I can see a listing of my courses
  def mycourses_teacher
    if not user_signed_in?
      render :json => {"error" => "Sinun täytyy ensin kirjautua sisään."}, status: 401
    elsif current_user.courses_to_teach.empty?
      render :json => {}, status: 200
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
      render :json => result, status:200
    end
  end

  #Teacher – I can create coursekeys for students to join my course
  def newcourse
    @course = Course.new(course_params)
    if not user_signed_in?
        render :json => {"error" => "Sinun täytyy ensin kirjautua sisään."}, status: 401
    elsif not Course.where(coursekey: @course.coursekey).empty?
        render :json => {"error" => "Kurssiavain on jo varattu."}, status: 403
    elsif @course.save
        Teaching.create(user_id: current_user.id, course_id: @course.id)
        if params[:exercises]
          exercises = params[:exercises]
          exercises.each do |key, value|
            Exercise.create(html_id: value, course_id: @course.id)  
          end
          render :json => {"message" => "Uusi kurssi luotu!"}, status: 200        
        else
          render :json => {"message" => "Kurssi luotu ilman tehtäviä."}, status: 202
        end
    else
        render :json => {"error" => "Kurssia ei voida tallentaa tietokantaan."}, status: 422
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.permit(:html_id, :coursekey, :name, :startdate, :enddate, :exercises)
    end
end

