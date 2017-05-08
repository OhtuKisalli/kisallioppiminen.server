class UsersController < ApplicationController
  before_action :check_admin, only: [:index]

  protect_from_forgery unless: -> { request.format.json? }

  # GET /users
  # GET /users.json
  def index
    @users = UserService.all_users
  end

  # Frontend session/cookies
  def is_user_signed_in
      render :json => {"has_sign_in": user_signed_in?}
  end

  # Frontend session/cookies
  def get_session_user
      u = current_user
      if current_user
        render :json => {"has_sign_in": {"id": u.id, "first_name": u.first_name, "teacher": TeachingService.is_teacher?(u.id), "student": AttendanceService.is_student?(u.id)}}
      else
        render :json => {"has_sign_in" => nil}
      end
  end
  
end
