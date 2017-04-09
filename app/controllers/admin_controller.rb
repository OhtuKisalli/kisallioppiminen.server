class AdminController < ApplicationController
  before_action :check_admin

  # get '/admins/exerciselists/'
  def sync_exercises_index
    @exerciselists = ExerciselistService.all_exerciselists
    render :sync_exercises_index  
  end
  
  # post '/admins/exerciselists/new'
  # params: hid (html_id), url
  def sync_exercises_new
    @hid = params[:hid]
    @url = params[:url]
    @exercises = nil
    if @hid.blank? or @url.blank? or not @url.include? @hid
      @error = "Virheelliset parametrit!"
      redirect_to '/admins/exerciselists/', notice: "Parametrit virheelliset!"
    elsif ExerciselistService.elist_id_by_html_id(@hid)
      @current_exs = ExerciselistService.exercises_by_html_id(@hid)
      kisalli_exs = AdminService.download_exercises(@url)
      @new = kisalli_exs - @current_exs
      @removed = @current_exs - kisalli_exs
      render :sync_exercises_update
    else
      @exercises = AdminService.download_exercises(@url)
      render :sync_exercises_new
    end
  end
  
  # delete '/admins/exerciselists/:id'
  def sync_exercises_delete
    Exerciselist.delete(params[:id])
    redirect_to '/admins/exerciselists/', notice: 'Tehtäväpohjan tehtävät poistettu!'
  end
  
  # post '/admins/exerciselists/save'
  def sync_exercises_save
    AdminService.save_exercises(params[:exercises], params[:hid])
    redirect_to '/admins/exerciselists/', notice: "Tehtävät tallennettu!"
  end
  
  # post '/admins/exerciselists/update'
  def sync_exercises_update
    AdminService.add_exercises(params[:exercises], params[:hid])
    redirect_to '/admins/exerciselists/', notice: "Uudet tehtävät tallennettu!"
  end
  
  # get '/admins/courses/'
  def fake_courses_index
    @fcourses = SecurityService.fake_courses?
    render :fake_courses_index
  end
  
  # delete '/admins/courses/'
  # params: id (Course.id)
  def fake_courses_delete
    CourseService.delete_course(params[:id])
    redirect_to '/admins/courses/', notice: "Kurssi poistettu!"
  end
  
  # delete '/admins/users/:id/courses' => 
  # params: id (User.id)
  def fake_courses_delete_all
    SecurityService.delete_all_courses(params[:id])
    redirect_to '/admins/courses/', notice: "Kaikki käyttäjän kurssit poistettu!"
  end
  
  # post '/admins/users/:id/block' 
  # params: id (User.id)
  def block_user
    SecurityService.block_user(params[:id])
    redirect_to '/users/', notice: "Käyttäjä ei voi enää luoda kursseja."
  end
  
  # post '/admins/users/:id/unblock' 
  # params: id (User.id)
  def unblock_user
    SecurityService.unblock_user(params[:id])
    redirect_to '/users/', notice: "Käyttäjän blokkaus poistettu. Hän voi taas luoda kursseja."
  end
  

end

