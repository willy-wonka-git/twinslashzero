class UsersController < ApplicationController
  load_and_authorize_resource
  skip_before_action :verify_authenticity_token, only: [:create]

  def index
    @users = User.order(:nickname).page params[:page]
  end

  def show
    @user = User.find(params[:id])
  end
end
