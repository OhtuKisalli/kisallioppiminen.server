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
    @notice = nil
    if @hid.blank? or @url.blank? or not @url.include? @hid
      @notice = "Virheelliset parametrit!"
      redirect_to '/admins/exerciselists/', notice: "Parametrit virheelliset!"
    elsif ExerciselistService.elist_id_by_html_id(@hid)
      redirect_to '/admins/exerciselists/', notice: "Kyseinen kurssipohjan id löytyy jo tietokannasta!"
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

end

