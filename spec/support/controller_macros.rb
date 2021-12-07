module ControllerMacros
  def login_user(type = :user, user = nil)
    user ||= FactoryBot.create(type)
    sign_in user
    Current.user = user
  end
end
