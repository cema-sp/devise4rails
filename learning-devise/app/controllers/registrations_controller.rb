class RegistrationsController < Devise::RegistrationsController

  # def destroy
  #   redirect_to root_path
  # end
  def index
    @users = User.all
  end
  def show
    @id = params[:id]
    # logger.info caller
    redirect_to root_path unless (@show_user = User.find(@id))
  end
end
