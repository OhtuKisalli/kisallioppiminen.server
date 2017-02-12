class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token

  # Return to original location after login
  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || "https://ohtukisalli.github.io/"
  end

  def after_sign_out_path_for(resource_or_scope)
    request.env['omniauth.origin'] || stored_location_for(resource_or_scope) || "https://ohtukisalli.github.io/"
  end

end
