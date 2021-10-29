class UsersController < ApplicationController
  load_and_authorize_resource
  skip_before_action :verify_authenticity_token, only: [:create]

  def index
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true).order(:nickname).page(params[:page])
  end

  def show
    @user = User.find(params[:id])
  end
end
