# Captiva Tecnología Digital
# by: Christian Estrella
# date: January 2013

class User < ActiveRecord::Base
  belongs_to :company
  accepts_nested_attributes_for :company
  
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :company_id, :company_attributes
  # attr_accessible :title, :body
  
  def self.subscribe(user)
      unless user.company.id?
        $redis.set user.company.id.to_s, user.id.to_s
      else
        $redis.get(user.company.id).each do |x|
          p x
        end
      end
  end
end
