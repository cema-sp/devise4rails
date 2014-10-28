class RegistrationsController < Devise::RegistrationsController
  def destroy
    redirect_to root_path
  end
end
