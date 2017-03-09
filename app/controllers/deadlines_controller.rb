class DeadlinesController < ApplicationController
  
  before_action :check_signed_in, except: [:index, :show]
  
  # GET /deadlines
  def index
    @deadlines = DeadlineService.all_deadlines
  end
  
  def show
    @deadline = DeadlineService.deadline_by_id(params[:id])
  end
  
  # Teacher - create schedule
  # POST /courses/:id/deadlines/new
  # params: description, deadline (timestamp), exercises ["html_id1", "html_id2"]
  def newdeadline
    if not TeacherService.has_rights?(current_user.id, params[:id])
      render :json => {"error" => "Et ole kyseisen kurssin vastuuhenkilö."}, status: 401
    elsif not params[:description] or params[:description].blank?
      render :json => {"error" => "Aikataululla täytyy olla nimi."}, status: 422
    elsif not params[:deadline]
      render :json => {"error" => "Aikataululla täytyy olla päivämäärä."}, status: 422
    elsif not params[:exercises] or params[:exercises].size == 0
      render :json => {"error" => "Aikataululla täytyy olla vähintään yksi tehtävä."}, status: 422
    elsif DeadlineService.create_deadline(params[:id], params[:description], params[:deadline], params[:exercises])
      render :json => {"message" => "Aikataulu tallennettu tietokantaan."}, status: 200
    else
      render :json => {"error" => "Aikataulua ei voida tallentaa tietokantaan."}, status: 422
    end
  end

end
