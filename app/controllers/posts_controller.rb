class PostsController < ApplicationController
  load_and_authorize_resource
  
  before_action :set_post, only: [:show, :edit, :update, :destroy, :run, :draft, :approve, :ban, :archive, :publish]
  before_action :create_new_tags, only: [:create, :update]

  # GET /posts or /posts.json
  def index
    if params[:tag]
      @posts = Post.tagged_with(params[:tag])
      @title = params[:tag]
    else
      @posts = Post
    end
    @posts = @posts.published.page params[:page]
  end

  def moderate
    @posts = Post.not_moderated.page params[:page]
  end

  # GET /posts/1 or /posts/1.json
  def show; end

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
    render save_post
  end

  def ban
    @post.ban
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
        current_state: I18n.t("posts.states." + @post.aasm.current_state.to_s),
        message: I18n.t("posts.messages.post_was_successfully_updated"),
        content: (render_to_string partial: '/posts/state', locals: {post: @post}, layout: false )  
      }
    } 
  end
end
