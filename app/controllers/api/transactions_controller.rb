class Api::TransactionsController < Api::BaseApiController
  include TransactionProcessor
  before_action :authorize_merchant_token

  def create
    transaction_type = "#{params[:transaction_type]}_transaction".to_sym
    service_class = "Create#{params[:transaction_type].to_s.camelize}TransactionService".constantize
    result = service_class.call(transaction_params:, transaction_type:)

    if result.success?
      render json: result.form.model.reload, serializer: TransactionSerializer, status: :ok
    else
      render json: { error: result.message }, status: :unprocessable_entity
    end
  end

  private

  def authorize_merchant_token
    token = request.headers['Authorization']&.split(' ')&.last
    ApiToken.find_sole_by(token:, merchant: current_merchant)
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Unauthorized - Invalid merchant ID or api token' }, status: :unauthorized
  end

  def current_merchant
    @current_merchant ||= Merchant.find(params[:merchant_id])
  end
end
