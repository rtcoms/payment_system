class ValidateAuthorizeTransactionParams
  include Interactor

  def call
    authorize_transaction_params = context.authorize_transaction_params
    context.form = AuthorizeTransactionForm.new(AuthorizeTransaction.new(payment: Payment.new))

    context.fail!(message: context.form.errors.full_messages.join(', ')) unless context.form.validate(authorize_transaction_params)

    context.transaction_type = :authorize_transaction
    context.merchant_id = authorize_transaction_params[:merchant_id]
    context.amount = authorize_transaction_params[:payment][:amount]
    context.customer_email = authorize_transaction_params[:customer_email]
    context.customer_phone = authorize_transaction_params[:customer_phone]
    context.authorize_transaction_params = authorize_transaction_params
  end
end
