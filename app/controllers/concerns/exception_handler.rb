require 'active_record/errors'
require 'active_model'

module ExceptionHandler
  extend ActiveSupport::Concern

  ERRORS_404 = [ActiveRecord::RecordNotFound, ActionController::RoutingError].freeze
  ERRORS_400 = [
    ActionController::BadRequest,
    ActionController::ParameterMissing
  ].freeze
  APP_ERROS = ERRORS_404 + ERRORS_400

  included do
    rescue_from(*APP_ERROS) do |exception|
      log_error_with_context(exception)
      perform_redirect_on_error(exception)
    end
  end

  #To handle errors which are directly raise by rails router 
  # and request doesn't even go to controllers
  def route_not_found
    respond_to do |format|
      format.json { render json: { error: 'Invalid URL' }, status: :not_found }
      format.any { render plain: 'Error: Invalid URL', status: :not_found }
    end
  end



  private

  def perform_redirect_on_error(exception)
    status_number = exception_status_code(exception)
    error_message = "Error: #{status_number} - #{exception.message}"
    render(plain: error_message, status: status_number) and return if request.format.html?

    render json: { error: error_message }, status: :not_found if request.format.json?
  end

  # Return http status code for an exception
  #
  # @param exception [Exception] the exception object
  # @return [Integer] the http status code.
  # @!visibility private
  def exception_status_code(exception)
    return 404 if ERRORS_404.include?(exception.class)
    return 400 if ERRORS_400.include?(exception.class)

    500
  end

  # To log request parameters without sensitive data
  def log_error_with_context(exception)

    context_info = request_exception_context(request, exception)

    Rails.logger.tagged('ERROR') do
      Rails.logger.error("Error occurred: #{exception.message}")
      Rails.logger.error("Backtrace: #{exception.backtrace.join('\n')}")
      Rails.logger.error("Context: #{context_info}")
    end
  end

  def request_exception_context(request, exception)
    {
      message: exception.message,
      request_params: request.filtered_parameters,
      referrer: request.referer,
      user_agent: request.user_agent
    }
  end
end
