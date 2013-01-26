# Captiva Tecnología Digital
# by: Christian Estrella
# date: January 2013

class ApplicationController < ActionController::Base
  protect_from_forgery
 
  layout :layout_by_resource
  before_filter :set_locale, :authenticate_user!
 
  def set_locale
    I18n.locale = 'es'
    logger.debug "* Locale set to '#{I18n.locale}'"
  end
  
  def layout_by_resource
    if devise_controller?
      'empty'
    else
      'application'
    end
  end
end