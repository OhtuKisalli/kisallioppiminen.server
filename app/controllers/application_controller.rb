class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token

  helper_method :user_admin

  # Return to original location after login
  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || "https://ohtukisalli.github.io/"
  end

  def after_sign_out_path_for(resource_or_scope)
    request.env['omniauth.origin'] || stored_location_for(resource_or_scope) || "https://ohtukisalli.github.io/"
  end
  
  def check_signed_in
    if not user_signed_in?
      render :json => {"error" => "Sinun täytyy ensin kirjautua sisään."}, status: 401
    end
  end
  
  # temp fix. todo: admin-role
  def check_admin
    if Rails.env.production?
      render :json => {"error" => "Tarvitset admin-oikeudet kyseiseen toimintoon"}, status: 401
    end  
  end
  
  # temp fix
  def user_admin
    return (not Rails.env.production?)
  end

end
