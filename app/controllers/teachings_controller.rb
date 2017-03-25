class TeachingsController < ApplicationController
  before_action :check_signed_in
  before_action :check_admin, only: [:index]

  # GET /teachings
  def index
    @teachings = TeachingService.all_teachings
  end
  
  # Archive/recover course
  # POST 'teachers/:sid/courses/:cid/toggle_archived'
  # params: sid (User.id), cid (Course.id), archived ("true"/"false")
  def toggle_archived
    cid = params[:cid]
    sid = params[:sid]
    if sid.to_i != current_user.id
      render :json => {"error" => "Voit muuttaa vain omien kurssiesi asetuksia."}, status: 401
    elsif not TeachingService.teacher_on_course?(sid, cid)
      render :json => {"error" => "Et ole opettajana kyseisellä kurssilla."}, status: 403
    elsif params[:archived] == "false" or params[:archived] == "true"
      TeachingService.change_archived_status(sid, cid, params[:archived])
      if params[:archived] == "false"
        render :json => {"message" => "Kurssi palautettu arkistosta."}, status: 200
      else
        render :json => {"message" => "Kurssi arkistoitu."}, status: 200
      end
    else 
      render :json => {"error" => "Arkistointitiedon muuttaminen ei onnistunut."}, status: 422
    end
  end

end
