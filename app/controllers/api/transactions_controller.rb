class Api::TransactionsController < ApplicationController
  before_action :authenticate_request

  def create
    transaction_type = "#{params[:transaction_type]}_transaction".to_sym
    transaction_params = transaction_params_method
    service_class = "Create#{params[:transaction_type].to_s.camelize}TransactionService".constantize

    result = service_class.call(transaction_params: transaction_params, transaction_type: transaction_type)

    if result.success?
      render json: result.form.model, status: :ok
    else
      render json: { error: result.message }, status: :unprocessable_entity
    end
  end

  private

  def authenticate_request
    token = request.headers['Authorization']&.split(' ')&.last
    
    unless valid_token?(token)
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def valid_token?(token)
    token == Rails.application.config.api_settings['api_token']
  end

  def transaction_params_method
    params.permit(common_params, send("#{params[:transaction_type]}_params"))
  end

  def common_params
    %i[merchant_id customer_email customer_phone]
  end

  def authorize_params
    # Define parameters specific to the 'authorize' transaction type
    %i[txn_amount]
  end

  def charge_params
    %i[reference_transaction_id txn_amount]
  end

  def refund_params
    %i[reference_transaction_id txn_amount]
  end

  def reversal_params
    %i[reference_transaction_id]
  end
end
