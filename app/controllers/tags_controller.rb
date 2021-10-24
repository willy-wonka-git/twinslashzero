class TagsController < ApplicationController
  def search
    return [] unless params[:q].present?

    @tags = Tag.order(:name).where("lower(name) LIKE ?", "%#{params[:q]}%".downcase)
    render json: @tags.map { |v| v.serializable_hash(only: [:id, :name]) }
  end
end
