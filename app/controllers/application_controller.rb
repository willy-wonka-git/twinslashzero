class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_current_user

  around_action :switch_locale

  def default_url_options
    { locale: I18n.locale }
  end

  def switch_locale(&action)
    locale = I18n.default_locale
    locale = params[:locale] if params[:locale] && I18n.available_locales.include?(params[:locale].to_sym)
    I18n.with_locale(locale, &action)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in) do |u|
      u.permit(:nickname, :fullname, :decription, :email,
               :password, :password_confirmation)
    end
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:nickname, :fullname, :decription, :email,
               :password, :password_confirmation, :avatar)
    end
    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:nickname, :fullname, :decription,
               :email, :password, :password_confirmation, :current_password,
               :avatar)
    end
  end

  def set_current_user
    User.current_user = current_user || User.new({ role: :guest })
  end
end
