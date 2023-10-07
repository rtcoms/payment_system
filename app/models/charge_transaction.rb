class ChargeTransaction < Transaction
  include Transactions::WithReferenceTransaction

  PERMITTED_STATUSES = %w[approved refunded error].freeze

  has_one :payment, class_name: 'Payment', as: :monetizable, dependent: :destroy, required: true

  validates :status, presence: true, inclusion: { in: PERMITTED_STATUSES }

  private

  def valid_reference_transaction?
    reference_transaction.is_a?(valid_reference_transaction_type)
  end

  def valid_reference_transaction_type
    AuthorizeTransaction
  end

  def valid_statuses_for_reference_transaction
    # AuthorizeTransaction would be reference transction here
    %w[approved]
  end
end
