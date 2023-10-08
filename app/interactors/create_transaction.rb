class CreateTransaction
  include Interactor

  def call
    if context.form.save
      #TODO: ideally this should be happening via state machine transition
      update_reference_transaction_status
    else
      model = context.form.model 
      if model.errors.full_messages.include?('Reference transaction must be approved or refunded')
        model.status = :error
        model.save(validate: false)
      end
    end
  end

  private

  def update_reference_transaction_status
    if context.transaction_type == :refund_transaction
      context.reference_transaction.update!(status: :refunded)
    elsif context.transaction_type == :reversal_transaction
      context.reference_transaction.update!(status: :reversed)
    end
  end
end