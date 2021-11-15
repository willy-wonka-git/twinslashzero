module ControllerMacros
  def login_admin
    admin = FactoryBot.create(:admin)
    sign_in admin
    User.current_user = admin
  end

  def login_user
    user = FactoryBot.create(:user)
    sign_in user
    User.current_user = user
  end
end
