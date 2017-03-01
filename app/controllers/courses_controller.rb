class CoursesController < ApplicationController
  
  before_action :set_course, only: [:show]
  
  protect_from_forgery unless: -> { request.format.json? }

  # Backend
  # /courses
  def index
    @courses = Course.all
  end

  # Backend
  # /courses/:id
  def show
  end

  # Update course
  # PUT 'courses/:id'
  # params: id, coursekey, name, startdate, enddate
  def update
    if not user_signed_in?
      render :json => {"error" => "Sinun täytyy ensin kirjautua sisään."}, status: 401
    elsif current_user.courses_to_teach.where(id: params[:id]).empty?
      render :json => {"error" => "Et ole kyseisen kurssin opettaja."}, status: 401
    elsif Course.where(coursekey: params[:coursekey]).any?
      render :json => {"error" => "Kurssiavain on jo varattu."}, status: 403
    else
      @course = Course.find(params[:id])
      @course.coursekey = params[:coursekey]
      @course.name = params[:name]
      @course.startdate = params[:startdate]
      @course.enddate = params[:enddate]
      if @course.save
        render :json => {"message" => "Kurssitiedot päivitetty."}, status: 200
      else
        render :json => {"error" => "Kurssia ei voida tallentaa tietokantaan."}, status: 422
      end
    end
  end
  
  # Teacher – I can see a listing of my courses
  # GET '/teachers/:id/courses'
  # params: id (User.id) - doesn't matter what, no need to be same as current_user
  def mycourses_teacher
    if not user_signed_in?
      render :json => {"error" => "Sinun täytyy ensin kirjautua sisään."}, status: 401
    elsif current_user.courses_to_teach.empty?
      render :json => {}, status: 200
    else
      @courses = current_user.courses_to_teach
      result = build_coursehash(@courses, "teacher")
      render :json => result, status:200
    end
  end
     
  # Student - Courses
  # get '/students/:id/courses'
  # params: id (User.id)
  def mycourses_student
    sid = params[:id]
    if not user_signed_in?
      render :json => {"error" => "Sinun täytyy ensin kirjautua sisään."}, status: 401
    elsif sid.to_i != current_user.id
      render :json => {"error" => "Voit hakea vain omat kurssisi."}, status: 401
    else
      @courses = current_user.courses
      result = build_coursehash(@courses, "student")
      render :json => result, status:200
    end
  end
    
  # Teacher – I can create coursekeys for students to join my course
  # post '/courses/newcourse'
  # params: coursekey, name, html_id, startdate, enddate, exercises (json)
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
  
    def build_coursehash(courses, target)
    result = []
      courses.each do |c|
        courseinfo = c.courseinfo
        if target == "teacher"
          courseinfo["archived"] = Teaching.where(user_id: current_user.id, course_id: c.id).first.archived
        elsif target == "student"
          courseinfo["archived"] = Attendance.where(user_id: current_user.id, course_id: c.id).first.archived
        end
        result << courseinfo
      end
      return result
    end
  
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.permit(:html_id, :coursekey, :name, :startdate, :enddate, :exercises)
    end
    
end

