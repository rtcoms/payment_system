# Service to create transaction and update status of reference transaction
# It uses respective form classes to create transaction
class CreateTransaction
  include Interactor

  def call
    # Create transaction
    if context.form.save
      update_reference_transaction_status
    else
      # Create transaction
      model = context.form.model 
      if model.errors.full_messages.include?('Reference transaction must be approved or refunded')
        # Mark transaction as erronous if reference transaction status is
        # anything other than approved or refunded
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