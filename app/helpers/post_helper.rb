module PostHelper
  def post_defaults(post)
    post.author = current_user
    post.category = PostCategory.find(post.category_id) if post.category_id
  end

  def group_action_valid?(params)
    valid = !(action_type_valid?(params, params["type"]) && params["posts"].empty?)
    render json: { message: "Wrong parameters", statusText: "error", status: :unprocessable_entity } unless valid
    valid
  end

  def action_valid?(params, post, type)
    can_invalid = !can?(params["type"], post)
    !(action_type_valid?(params, type) && can_invalid)
  end

  private

  def action_type_valid?(params, type)
    reason_invalid = (%w[ban reject].include?(type) && !params["reason"])
    type && !(%w[ban approve reject delete].exclude?(type) || reason_invalid)
  end

  def post_partial(post, name, params = nil)
    params ||= { locals: { post: post }, layout: false }
    render_to_string partial: "/posts/#{name}", **params
  end

  def save_render_post_after_action(post)
    post.save
    { json: {
      id: post.id.to_s,
      current_state: I18n.t("posts.states.#{post.aasm.current_state}"),
      message: I18n.t("posts.messages.post_was_successfully_updated"),
      state_panel: post_partial(post, :state),
      state_dropdown: post_partial(post, :state_dropdown),
      history_panel: post_partial(post, :post_history,
                                  { locals: { post_history: post.post_history }, layout: false }),
      actions_panel: post_partial(post, :post_actions)
    } }
  end

  def change_post_state(params, post, state_action)
    unless action_valid?(params, post, state_action)
      return render json: { message: "Wrong parameters", statusText: "error", status: :unprocessable_entity }
    end

    post.send(state_action)
    post.state_reason = params["reason"]
    save_render_post_after_action(post)
  end

  def group_action(params)
    params["posts"].each do |post_id|
      post = Post.find(post_id)
      post.state_reason = params["reason"]
      post.send(params["type"])
      post.save
    end
  end

  def group_action_success(type, posts)
    { json: {
      message: I18n.t("posts.messages.post_was_successfully_#{type == 'delete' ? 'destroyed' : 'updated'}"),
      statusText: "success",
      adverts_html: (render_to_string partial: '/posts/list', locals: { posts: posts, moderate: true },
                                      layout: false)
    } }
  end

  def remove_photos?(params)
    params[:post] && params[:post][:remove_photos] == "1"
  end
end
