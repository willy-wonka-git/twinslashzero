class TagsController < ApplicationController
  load_and_authorize_resource

  def search
    return [] if params[:q].blank?

    @tags = Tag.order(:name).where("lower(name) LIKE ?", "%#{params[:q]}%".downcase)
    render json: @tags.map { |v| v.serializable_hash(only: [:id, :name]) }
  end
end
