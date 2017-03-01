class TeachingsController < ApplicationController
  before_action :check_signed_in, except: [:index]

  # GET /teachings
  def index
    @teachings = Teaching.all
  end
  
  # Archive/recover course
  # POST 'teachers/:sid/courses/:cid/toggle_archived'
  # params: sid (User.id), cid (Course.id), archived ("true"/"false")
  def toggle_archived
    sid = params[:sid]
    cid = params[:cid]
    if sid.to_i != current_user.id
      render :json => {"error" => "Voit muuttaa vain omien kurssiesi asetuksia."}, status: 401
    elsif Teaching.where(user_id: sid, course_id: cid).empty?
      render :json => {"error" => "Et ole opiskelijana kyseisellä kurssilla."}, status: 403
    elsif params[:archived] == "true" or params[:archived] == "false"
      a = Teaching.where(user_id: sid, course_id: cid).first    
      if params[:archived] == "false"
        a.archived = false
        a.save
        render :json => {"message" => "Kurssi palautettu arkistosta."}, status: 200
      else
        a.archived = true
        a.save  
        render :json => {"message" => "Kurssi arkistoitu."}, status: 200
      end
    else 
      render :json => {"error" => "Arkistointitiedon muuttaminen ei onnistunut."}, status: 422
    end
  end

end
