class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def vkontakte
    @user = User.from_vkontakte_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      flash[:notice] = I18n.t("devise.omniauth_callbacks.success", kind: "Vkontakte")
    else
      session["devise.vkontakte_data"] = request.env["omniauth.auth"].except(:extra)
      redirect_to new_user_registration_url
    end
  end

  def twitter
    @user = User.from_twitter_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      flash[:notice] = I18n.t("devise.omniauth_callbacks.success", kind: "Twitter")
    else
      session["devise.twitter_data"] = request.env["omniauth.auth"].except(:extra)
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
    flash[:error] = I18n.t("devise.omniauth_callbacks.failure", kind: "service", reason: "Unknown error")
  end
end
