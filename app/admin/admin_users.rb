include AdminUsersHelper

ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  create_or_edit = proc do
    admin_user = create_admin_user
    return unless admin_user

    redirect_to admin_admin_user_path(id: admin_user.id) if create_user
  end

  member_action :create, method: :post, &create_or_edit
  member_action :update, method: :put, &create_or_edit
  # member_action :delete, method: :delete, &destroy
  # # TODO or change AdminUser to User
  # http://dan.doezema.com/2012/02/how-to-implement-a-single-user-model-with-rails-activeadmin-and-devise/
end
