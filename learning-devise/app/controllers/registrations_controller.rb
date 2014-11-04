class RegistrationsController < Devise::RegistrationsController

  # def destroy
  #   redirect_to root_path
  # end
  # def update
  #   account_update_params = devise_parameter_sanitizer.sanitize(:account_update)
  #   if account_update_params[:password].blank?
  #     account_update_params.delete("password")
  #     account_update_params.delete("password_confirmation")
  #   end
  # end
  def update
    @user = User.find(current_user.id)

    successfully_updated = if needs_password?(@user,params)
      @user.update_with_password(devise_parameter_sanitizer.sanitize(:account_update))
    else
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
      params[:user].delete(:current_password)
      @user.update_without_password(devise_parameter_sanitizer.sanitize(:account_update))
    end

    if successfully_updated
      set_flash_message :notice, :updated

      sign_in @user, :bypass => true
      redirect_to after_update_path_for(@user)
    else
      render "edit"
    end
  end
  def index
    @users = User.all
  end
  def show
    @id = params[:id]
    # logger.info caller
    redirect_to root_path unless (@show_user = User.find(@id))
  end

  private

    def needs_password?(user,params)
      # change in username/email, new password
      user.email != params[:user][:email] ||
        user.username != params[:user][:username] || 
        params[:user][:password].present?
    end
end
