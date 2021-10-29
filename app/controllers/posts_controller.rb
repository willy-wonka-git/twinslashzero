class PostsController < ApplicationController
  load_and_authorize_resource

  before_action :set_post,
                only: [:show, :edit, :update, :destroy, :run, :draft, :reject, :approve, :ban, :archive, :publish]
  before_action :create_new_tags, only: [:create, :update]
  after_action :save_post_history, only: [:create, :update, :run, :draft, :reject, :ban, :approve, :archive, :publish]

  # GET /posts or /posts.json
  def index
    @q = Post.ransack(params[:q])
    posts = @q.result(distinct: true)
    if params[:tag]
      @title = params[:tag]
      posts = posts.tagged_with(params[:tag])
    end
    @posts = posts.published.page(params[:page])
  end

  def moderate
    @q = Post.ransack(params[:q])
    posts = @q.result(distinct: true)
    @posts = posts.not_moderated.page(params[:page])
  end

  # GET /posts/1 or /posts/1.json
  def show
    @post_history = @post.post_history
  end

  # GET /posts/new
  def new
    @post = Post.new
    @post.author = current_user
  end

  # GET /posts/1/edit
  def edit; end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)
    @state_reason = "create"
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

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      @post.published_at = Time.now
      if @post.update(post_params)
        format.html { redirect_to @post, notice: t("posts.messages.post_was_successfully_updated") }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: t("posts.messages.post_was_successfully_destroyed") }
      format.json { head :no_content }
    end
  end

  def run
    @post.run
    render save_post
  end

  def draft
    @post.draft
    render save_post
  end

  def reject
    @post.reject
    @state_reason = params["reason"]
    render save_post
  end

  def ban
    @post.ban
    @state_reason = params["reason"]
    render save_post
  end

  def approve
    @post.approve
    render save_post
  end

  def publish
    @post.publish
    render save_post
  end

  def archive
    @post.archive
    render save_post
  end

  private

  def set_post_defaults
    @post.author = current_user
    @post.category = PostCategory.find(@post.category_id) if @post.category_id
    @post.published_at = Time.now
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:category_id, :title, :content, :tag_list, :tag, { tag_ids: [] }, :tag_ids,
                                 { photos: [] }, :photos)
  end

  def create_new_tags
    params[:post][:tag_ids].each_with_index do |tag_id, index|
      next unless tag_id.include?("#(new)")

      tag = Tag.find_or_create_by(name: tag_id.sub("#(new)", ""))
      tag.save unless tag.id
      params[:post][:tag_ids][index] = tag.id.to_s
    end
  end

  def save_post
    @post.published_at = @post.aasm_state == :published.to_s ? Time.now : nil
    @post.save
    {
      json: {
        id: @post.id.to_s,
        current_state: I18n.t("posts.states.#{@post.aasm.current_state}"),
        message: I18n.t("posts.messages.post_was_successfully_updated"),
        state_panel: (render_to_string partial: '/posts/state', locals: { post: @post }, layout: false),
        state_dropdown: (render_to_string partial: '/posts/state_dropdown', locals: { post: @post }, layout: false)
      }
    }
  end

  def save_post_history
    return if @post.post_history.first && @post.post_history.first.state == @post.aasm.current_state.to_s

    post_history = PostHistory.create({ post: @post, user: current_user, state: @post.aasm.current_state })
    post_history.reason = @state_reason if defined? @state_reason
    post_history.save
  end
end
