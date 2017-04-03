class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token

  helper_method :user_admin

  # Return to original location after login
  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  end

  def after_sign_out_path_for(resource_or_scope)
    request.env['omniauth.origin'] || stored_location_for(resource_or_scope) || root_path
  end
  
  def check_signed_in
    if not user_signed_in?
      render :json => {"error" => "Sinun täytyy ensin kirjautua sisään."}, status: 401
    end
  end
  
  def check_admin
    if not user_admin
      render :json => {"error" => "Tarvitset admin-oikeudet kyseiseen toimintoon"}, status: 401
    end  
  end

  def user_admin
    return (user_signed_in? and current_user.admin)
  end

end
