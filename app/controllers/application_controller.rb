# require 'pry'
class ApplicationController < ActionController::Base
  around_action :switch_locale

  def default_url_options
    { locale: I18n.locale }
  end

  def switch_locale(&action)
    locale = I18n.default_locale
    if params[:locale] && I18n.available_locales.include?(params[:locale].to_sym) then
      locale = params[:locale]
    end  
    # binding.pry
    I18n.with_locale(locale, &action)
  end
end
