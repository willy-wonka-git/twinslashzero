class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_current_user
  before_action :create_new_tags

  around_action :switch_locale

  def default_url_options
    { locale: I18n.locale }
  end

  def switch_locale(&action)
    locale = I18n.default_locale
    locale = params[:locale] if params[:locale] && I18n.available_locales.include?(params[:locale].to_sym)
    I18n.with_locale(locale, &action)
  end

  def create_new_tags
    Tag.create_new_tags(params[:post][:tag_ids]) if defined? params[:post][:tag_ids]
  end

  def authenticate_active_admin_user!
    authenticate_user!
    redirect_to root_path, notice: I18n.t("errors.messages.unauthorized_access") unless current_user.admin?
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in) do |u|
      u.permit(:nickname, :fullname, :decription, :email, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:nickname, :fullname, :decription, :email, :password, :password_confirmation, :avatar)
    end
    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:nickname, :fullname, :decription, :email, :password, :password_confirmation, :current_password,
               :avatar)
    end
  end

  def set_current_user
    Current.user = current_user
  end
end
