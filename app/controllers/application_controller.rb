class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |_exception|
    flash[:alert] = 'You are not authorized to access this resource.'

    redirect_to root_path
  end

  def route_not_found
    respond_to do |format|
      format.json { render json: { error: 'Invalid URL' }, status: :not_found }
      format.any { render plain: 'Error: Invalid URL', status: :not_found }
    end
  end
end
