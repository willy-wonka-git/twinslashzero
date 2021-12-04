class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def vkontakte
    auth(__method__)
  end

  def twitter
    auth(__method__)
  end

  def failure
    redirect_to root_path
    flash[:error] = I18n.t("devise.omniauth_callbacks.failure", kind: "service", reason: "Unknown error")
  end

  private

  def auth(auth_name)
    @user = User.send("from_#{auth_name}_omniauth", request.env["omniauth.auth"])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      flash[:notice] = I18n.t("devise.omniauth_callbacks.success", kind: auth_name.capitalize)
    else
      session["devise.#{auth_name}_data"] = request.env["omniauth.auth"].except(:extra)
      redirect_to new_user_registration_url
    end
  end

end
