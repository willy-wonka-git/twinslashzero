class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # skip_before_action :verify_authenticity_token, only: [:vkontakte, :twitter]

  def vkontakte
    @user = User.from_vkontakte_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      # remember_me(@user)
      sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
      flash[:notice] = I18n.t("devise.omniauth_callbacks.success", :kind => "Vkontakte")
      # set_flash_message(:notice, :success, kind: "VKonakte") if is_navigational_format?
    else
      session["devise.vkontakte_data"] = request.env["omniauth.auth"].except(:extra) # Removing extra as it can overflow some session stores
      redirect_to new_user_registration_url
    end    
  end

  def twitter
    @user = User.from_twitter_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      flash[:notice] = I18n.t("devise.omniauth_callbacks.success", :kind => "Twitter")
    else
      session["devise.twitter_data"] = request.env["omniauth.auth"].except(:extra)
      redirect_to new_user_registration_url
    end    
  end

  # def github; end
  
  # def facebook; end

  def failure
    redirect_to root_path
    flash[:error] = I18n.t("devise.omniauth_callbacks.failure", kind: "service", reason: "Unknown error")
  end
end
