class ValidateAuthorizeTransactionParams
  include Interactor

  def call
    transaction_params = context.transaction_params
    context.form = AuthorizeTransactionForm.new(AuthorizeTransaction.new(payment: Payment.new))

    unless context.form.validate(transaction_params)
      context.fail!(message: context.form.errors.full_messages.join(', '))
    end

    context.transaction_type = :authorize_transaction
    context.merchant_id = transaction_params[:merchant_id]
    context.amount = transaction_params[:payment][:amount]
    context.customer_email = transaction_params[:customer_email]
    context.customer_phone = transaction_params[:customer_phone]
    context.transaction_params = transaction_params
  end
end
