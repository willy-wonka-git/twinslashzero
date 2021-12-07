class UsersController < ApplicationController
  include ApplicationHelper

  load_and_authorize_resource
  skip_before_action :verify_authenticity_token

  def index
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true).order(:nickname).page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @posts = if admin? || current_user == @user
               Post.by_author(@user).page(params[:page])
             else
               Post.published.by_author(@user).page(params[:page])
             end
  end

  def destroy
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.destroy
        format.html { redirect_to users_url, notice: "User was successfully destroyed." }
        format.json { head :no_content }
      else
        format.html { redirect_to users_url, error: "User wasn't destroyed." }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
end
