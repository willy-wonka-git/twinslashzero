class PostsController < ApplicationController
  load_and_authorize_resource

  before_action :set_post,
                only: [:show, :edit, :update, :destroy, :run, :draft, :reject, :approve, :ban, :archive, :publish]

  def index
    @q = Post.ransack(params[:q])
    posts = @q.result(distinct: true).includes(:tags)
    if params[:tag]
      @title = params[:tag]
      posts = Tag.tagged_with(params[:tag])
    end
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
    @post = Post.new
    @post.author = current_user
  end

  def edit; end

  def create
    @post = Post.new(post_params)
    @post.state_reason = "create"
    set_post_defaults

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: t("posts.messages.post_was_successfully_created") }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      @post.published_at = Time.zone.now
      if @post.update(post_params)
        format.html { redirect_to @post, notice: t("posts.messages.post_was_successfully_updated") }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: t("posts.messages.post_was_successfully_destroyed") }
      format.json { head :no_content }
    end
  end

  def run
    render change_post_state(__method__)
  end

  def draft
    render change_post_state(__method__)
  end

  def reject
    render change_post_state(__method__)
  end

  def ban
    render change_post_state(__method__)
  end

  def approve
    render change_post_state(__method__)
  end

  def publish
    render change_post_state(__method__)
  end

  def archive
    render change_post_state(__method__)
  end

  def action
    if !params["type"]\
       || params["posts"].empty?\
       || %w[ban approve reject delete].exclude?(params["type"])\
       || (%w[ban reject].include?(params["type"]) && !params["reason"])
      render json: { message: "Wrong parameters", statusText: "error", status: :unprocessable_entity }
    end

    params["posts"].each do |post_id|
      @post = Post.find(post_id)
      @post.send(params["type"])
      @post.state_reason = params["reason"]
      @post.save
    end

    message = I18n.t("posts.messages.post_was_successfully_updated") unless params["type"] == "delete"
    message = I18n.t("posts.messages.post_was_successfully_destroyed") if params["type"] == "delete"

    @q = Post.ransack(params[:q])
    posts = @q.result(distinct: true)
    @posts = posts.not_moderated.page(params[:page])

    render json: {
      message: message,
      statusText: "success",
      adverts_html: (render_to_string partial: '/posts/list', locals: { posts: @posts, moderate: true }, layout: false)
    }
  end

  private

  def set_post_defaults
    @post.author = current_user
    @post.category = PostCategory.find(@post.category_id) if @post.category_id
    @post.published_at = Time.zone.now
  end

  def set_post
    @post = Post.find(params[:id])
    @post.state_reason = nil
  end

  def post_params
    params.require(:post).permit(:category_id, :title, :content, :tag_list, { tag_ids: [] }, { photos: [] }, :photos)
  end

  def change_post_state(state_action)
    @post.send(state_action)
    @post.state_reason = params["reason"]
    save_post
  end

  def save_post
    @post.published_at = @post.aasm_state == :published.to_s ? Time.zone.now : nil
    @post.save
    return {
      json: {
        id: @post.id.to_s,
        current_state: I18n.t("posts.states.#{@post.aasm.current_state}"),
        message: I18n.t("posts.messages.post_was_successfully_updated"),
        state_panel:    (render_to_string partial: '/posts/state',
                                          locals: { post: @post }, layout: false),
        state_dropdown: (render_to_string partial: '/posts/state_dropdown',
                                          locals: { post: @post }, layout: false),
        history_panel:  (render_to_string partial: '/posts/post_history',
                                          locals: { post_history: @post.post_history }, layout: false),
        actions_panel:  (render_to_string partial: '/posts/post_actions',
                                          locals: { post: @post }, layout: false)
      }
    }
  end
end
