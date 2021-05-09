class RegistrationsController < Devise::RegistrationsController
  
  def update
    super
    if account_update_params[:avatar].present?
      resource.avatar.attach(account_update_params[:avatar])
    end
  end
  
  protected
    def update_resource(resource, params)
      resource.update_without_password(params)
    end
end