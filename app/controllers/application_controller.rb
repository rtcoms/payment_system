class ApplicationController < ActionController::Base
  include ExceptionHandler

  rescue_from CanCan::AccessDenied do |_exception|
    flash[:alert] = 'You are not authorized to access this resource.'

    redirect_to root_path
  end
end
