# Captiva Tecnología Digital
# by: Christian Estrella
# date: January 2013

class AutocompletesController < ApplicationController
  before_filter :authenticate_user!, :except => [ :search_company_by_name ]
   
  def search_company_by_name
    if params[:term]
      companies = Company.find(:all, :conditions => [ "name like ?", "%#{params[:term]}%" ])
    else
      companies = Company.all
    end
    
    list = companies.map {|u| Hash[ id: u.id, label: u.name, name: u.name]}
      render json: list
  end
end
