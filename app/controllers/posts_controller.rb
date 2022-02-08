class PostsController < ApplicationController
  include PostHelper

  load_and_authorize_resource

  before_action :set_post,
                only: [:show, :edit, :update, :destroy, :run, :draft, :reject, :approve, :ban, :archive, :publish,
                       :image]
  before_action :set_new_post, only: [:new, :new_post_image]

  def index
    @q = Post.ransack(params[:q])
    posts = @q.result(distinct: true).includes(:tags)
    @posts = posts.published.order(:published_at).page(params[:page])
  end

  def moderate
    @q = Post.ransack(params[:q])
    posts = @q.result(distinct: true)
    @posts = posts.not_moderated.page(params[:page])
  end

  def show
    @post_history = @post.post_history
  end

  def new
    @post.cache_photos
  end

  def edit
    @post.cache_photos
  end

  def create
    @post = Post.new(post_params)
    post_defaults(@post)

    respond_to do |format|
      new_post = @post.id.blank?
      if @post.save
        format.html { redirect_to @post, notice: t("posts.messages.post_was_successfully_created") }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
      @post.save_photos(new_post: new_post)
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: t("posts.messages.post_was_successfully_updated") }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
      @post.save_photos
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: t("posts.messages.post_was_successfully_destroyed") }
    end
  end

  def run
    render change_post_state(params, @post, __method__)
  end

  def draft
    render change_post_state(params, @post, __method__)
  end

  def reject
    render change_post_state(params, @post, __method__)
  end

  def ban
    render change_post_state(params, @post, __method__)
  end

  def approve
    render change_post_state(params, @post, __method__)
  end

  def publish
    render change_post_state(params, @post, __method__)
  end

  def archive
    render change_post_state(params, @post, __method__)
  end

  def image
    render @post.photo_handler(params: params)
  end

  def new_post_image
    image
  end

  def action
    return unless group_action_valid?(params)

    group_action(params)
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).not_moderated.page(params[:page])
    render group_action_success(params["type"], @posts)
  end

  private

  def set_post
    @post = Post.find(params[:id])
    @post.state_reason = nil
  end

  def set_new_post
    @post = Post.new
    @post.author = Current.user
  end

  def post_params
    params.require(:post).permit(:category_id, :title, :content, :tag_list, { tag_ids: [] }, { photos_cache: [] })
  end
end
