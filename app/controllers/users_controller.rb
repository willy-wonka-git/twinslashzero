class UsersController < ApplicationController
  def index
    @users = User.order(:nickname).page params[:page]
  end

  def show
    @user = User.find(params[:id])
  end
end
