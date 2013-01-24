class RegistrationsController < Devise::RegistrationsController
  def new
    resource = build_resource({})
    resource.build_company
    respond_with resource
  end
end
