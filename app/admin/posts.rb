ActiveAdmin.register Post do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :author_id, :category_id, :published_at, :title, :content, :aasm_state, :state_reason
  #
  # or
  #
  # permit_params do
  #   permitted = [:author_id, :category_id, :published_at, :title, :content, :aasm_state, :state_reason]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  show do
    columns do
      column do
        panel "Post Details" do
          attributes_table_for post do
            row :id
            row :author
            row :category
            row :title
            row :content
            row 'Tags' do
              post.tags.each do |tag|
                tag
                text_node "&nbsp;".html_safe
              end
            end
          end
        end
      end

      column do
        panel "State history" do
          render partial: "posts/post_history", locals: { post_history: post.post_history(nil) }
        end
      end
    end
  end
end
