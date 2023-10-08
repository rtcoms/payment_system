class ValidateAuthorizeTransactionParams
  include Interactor

  def call
    authorize_transaction_params = context.authorize_transaction_params
      authorize_transaction_form = AuthorizeTransactionForm.new(AuthorizeTransaction.new(payment: Payment.new))
      
      if authorize_transaction_form.validate(authorize_transaction_params)
      context.authorize_transaction_params = authorize_transaction_params
    else
      context.fail!(message: authorize_transaction_form.errors.full_messages.join(', '))
    end
  end
end