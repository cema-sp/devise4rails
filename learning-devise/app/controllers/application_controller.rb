class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_filter :cancan_workaround

  rescue_from CanCan::AccessDenied do |exception|
    if current_user.nil?
      session[:next] = request.fullpath
      redirect_to new_user_session_url,
        alert: "Please sign in to continue"
    else
      if request.env["HTTP_REFERER"].present?
        redirect_to :back, alert: exception.message
      else
        render file: "#{Rails.root}/public/403.html", 
          status: 403, layout: false
      end
    end
  end

  protected
    def configure_permitted_parameters
      # devise_parameter_sanitizer.for(:sign_up) do |u|
      #   u.permit(:username, :email, :password, :password_confirmation, :remember_me)
      # end
      devise_parameter_sanitizer.for(:sign_up) << [:username, :email, :address]
      # devise_parameter_sanitizer.for(:sign_in) do |u|
      #   u.permit(:login, :password, :remember_me)
      # end
      devise_parameter_sanitizer.for(:sign_in) << :email
      # devise_parameter_sanitizer.for(:account_update) do |u|
      #   u.permit(:username, :email, :password, :password_confirmation, :remember_me)
      # end
      devise_parameter_sanitizer.for(:account_update) << [:username, :email, :address]
    end

    def cancan_workaround
      resource = controller_name.singularize.to_sym
      method = "#{resource}_params"
      params[resource] &&= send(method) if respond_to?(method, true)
    end
end
