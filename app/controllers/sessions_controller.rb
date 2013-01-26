# Captiva Tecnología Digital
# by: Christian Estrella
# date: January 2013

class SessionsController < Devise::SessionsController
  
  def create
    super
    
    unless authenticate_user!
      User.subscribe(current_user)
    end
  end
  
end
