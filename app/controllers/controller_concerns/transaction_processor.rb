module TransactionProcessor
  extend ActiveSupport::Concern

  private

  def transaction_params
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