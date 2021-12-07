class TagsController < ApplicationController
  load_and_authorize_resource

  def index
    tag_name = params[:tag]
    @title = tag_name
    @posts = Tag.tagged_with(tag_name).published.order(:published_at).page(params[:page])
    render "posts/index"
  end

  def search
    return [] if params[:q].blank?

    @tags = Tag.order(:name).where("lower(name) LIKE ?", "%#{params[:q]}%".downcase)
    render json: @tags.map { |v| v.serializable_hash(only: [:id, :name]) }
  end
end
