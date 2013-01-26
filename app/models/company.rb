# Captiva Tecnología Digital
# by: Christian Estrella
# date: January 2013

class Company < ActiveRecord::Base
  has_many :user
  
  attr_accessible :description, :name
  
  validates :name, :presence => true
end
