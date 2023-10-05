class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = 'You are not authorized to access this resource.'

    redirect_to root_path
  end
end
