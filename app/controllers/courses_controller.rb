class CoursesController < ApplicationController
  before_action :check_signed_in, except: [:index, :show]
  
  protect_from_forgery unless: -> { request.format.json? }

  # Backend
  # /courses
  def index
    @courses = CourseService.all_courses
  end

  # Backend
  # /courses/:id
  def show
    @course = CourseService.course_by_id(params[:id])
  end

  # Update course
  # PUT 'courses/:id'
  # params: id, coursekey, name, startdate, enddate
  def update
    if not TeacherService.teacher_on_course?(current_user.id, params[:id])
      render :json => {"error" => "Et ole kyseisen kurssin opettaja."}, status: 401
    elsif CourseService.coursekey_reserved?(params[:coursekey])
      render :json => {"error" => "Kurssiavain on jo varattu."}, status: 403
    else
      if CourseService.update_course?(params[:id], course_params)
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
    render :json => CourseService.teacher_courses(current_user.id), status: 200
  end
     
  # Student - Courses
  # get '/students/:id/courses'
  # params: id (User.id)
  def mycourses_student
    sid = params[:id]
    if sid.to_i != current_user.id
      render :json => {"error" => "Voit hakea vain omat kurssisi."}, status: 401
    else
      render :json => CourseService.student_courses(current_user.id), status: 200
    end
  end
    
  # Teacher – I can create coursekeys for students to join my course
  # post '/courses/newcourse'
  # params: coursekey, name, html_id, startdate, enddate, exercises (json)
  def newcourse
    if CourseService.coursekey_reserved?(params[:coursekey])
        render :json => {"error" => "Kurssiavain on jo varattu."}, status: 403
    else
      cid = CourseService.create_new_course(current_user.id, course_params)
      if cid > -1 and params[:exercises]
        ExerciseService.add_exercises_to_course(params[:exercises], cid)
        render :json => {"message" => "Uusi kurssi luotu!"}, status: 200        
      elsif cid > -1
        render :json => {"message" => "Kurssi luotu ilman tehtäviä."}, status: 202
      else
        render :json => {"error" => "Kurssia ei voida tallentaa tietokantaan."}, status: 422
      end
    end
  end

  private
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.permit(:html_id, :coursekey, :name, :startdate, :enddate, :exercises)
    end
    
end

