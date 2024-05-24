class ApplicationController < ActionController::API
  before_action :configure_permitted_parameters, if: :devise_controller?

  include ExceptionHandler

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :username])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password, :username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:email, :password, :username])
  end
end
