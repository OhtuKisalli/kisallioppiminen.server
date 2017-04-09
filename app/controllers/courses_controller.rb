class CoursesController < ApplicationController
  before_action :check_signed_in
  before_action :check_admin, only: [:index, :show]
  
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
    if not TeachingService.teacher_on_course?(current_user.id, params[:id])
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
  # params: coursekey, name, html_id, startdate, enddate
  def newcourse
    if CourseService.coursekey_reserved?(params[:coursekey])
        render :json => {"error" => "Kurssiavain on jo varattu."}, status: 403
    elsif UserService.user_blocked?(current_user.id)
        render :json => {"error" => "Et voi enää luoda kursseja, koska sinulle on väärinkäytösten vuoksi asetettu esto."}, status: 422
    elsif TeachingService.courses_created_today(current_user.id) >= MAX_COURSE_PER_DAY
        errormsg = "Voit luoda korkeintaan " + MAX_COURSE_PER_DAY.to_s + " kurssia päivässä."
        render :json => {"error" => errormsg}, status: 403
    elsif ExerciselistService.elist_id_by_html_id(params[:html_id]) == nil
        render :json => {"error" => "Kurssin tehtäviä ei vielä olla tallennettu tietokantaan."}, status: 422
    else
      cid = CourseService.create_new_course(current_user.id, course_params)
      if cid > -1
        render :json => {"message" => "Uusi kurssi luotu!"}, status: 200
      else
        render :json => {"error" => "Kurssia ei voida tallentaa tietokantaan."}, status: 422
      end
    end
  end
  
  # Exercise statistics of course
  # get '/courses/:id/exercises/statistics'
  # params: id (Course.id)
  # returns {"total": 30, "html_id1": {"green": 10, "red": 5, "yellow": 7},...}
  def exercise_stats
    if not TeachingService.teacher_on_course?(current_user.id, params[:id])
      render :json => {"error" => "Et ole kyseisen kurssin opettaja."}, status: 401  
    else
      stats = CourseService.statistics(params[:id])
      render :json => stats, status: 200
    end
  end

  private
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.permit(:html_id, :coursekey, :name, :startdate, :enddate, :exercises)
    end
    
end

