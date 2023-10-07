class RefundTransaction < Transaction
  include Transactions::WithReferenceTransaction

  has_one :payment, class_name: 'Payment', as: :monetizable, dependent: :destroy, required: true

  private

  def valid_reference_transaction?
    reference_transaction.is_a?(valid_reference_transaction_type)
  end

  def valid_reference_transaction_type
    ChargeTransaction
  end
end
