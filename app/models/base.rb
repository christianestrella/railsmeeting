# Captiva Tecnología Digital
# by: Christian Estrella
# date: January 2013

class Base < ActiveRecord::Base
  attr_accessible :key, :value
  
  def self.find_by_key(key, default)
    base = Base.where([ "key = ?", key ]).select("value").first # Se obtiene la configuración en base al key.
    
    unless base.nil? # Si base no es núlo se devuelve el valor.
      return base.value
    else # Sí base es núlo se devvuelve el default.
      return default
    end 
  end
end
