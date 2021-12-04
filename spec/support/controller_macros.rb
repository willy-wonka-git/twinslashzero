module ControllerMacros
  def login_user(type = :user)
    user = FactoryBot.create(type)
    sign_in user
    User.current_user = user
  end
end
