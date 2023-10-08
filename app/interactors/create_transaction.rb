class CreateTransaction
  include Interactor

  def call
    context.form.save

    #TODO: ideally this should be happening via state machine transition
    if context.transaction_type == :refund_transaction
      context.reference_transaction.update!(status: :refunded)
    elsif context.transaction_type == :reversal_transaction
      context.reference_transaction.update!(status: :reversed)
    end
  end
end