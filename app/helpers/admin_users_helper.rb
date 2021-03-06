module AdminUsersHelper
  def create_admin_user
    v = params[:admin_user]
    admin_user = AdminUser.find_or_create_by(id: params[:id])
    admin_user.email = v[:email]
    admin_user.password = v[:password]
    admin_user.save
    admin_user
  end

  def create_user
    v = params[:admin_user]
    user = User.find_or_create_by(email: params[:email])
    user.nickname = v[:email].split("@")[0]
    user.email = v[:email]
    user.password = v[:password]
    user.role = :admin
    user.save
    user
  end

  def delete_admin_user
    admin_user = AdminUser.find_by(id: params[:id])
    return false if !admin_user || admin_user.email == current_user.email || admin_user.email == "admin@gmail.com"

    user = User.find_by(email: admin_user.email)
    user.destroy if admin_user.destroy && user
  end
end
