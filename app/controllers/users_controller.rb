class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  protect_from_forgery unless: -> { request.format.json? }

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  def is_user_signed_in
      render :json => {"has_sign_in": user_signed_in?}
  end

  def get_session_user
      u = current_user
      render :json => {"has_sign_in": {"id": u.id, "first_name": u.first_name}}
  end
  
end
