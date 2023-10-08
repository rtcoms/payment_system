class CreateTransaction
  include Interactor

  def call
    if context.transaction_type == :authorize_transaction
      context.form.save
    end
  end
end