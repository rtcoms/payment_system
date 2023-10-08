class ChargeTransaction < Transaction
  include Transactions::WithReferenceTransaction

  PERMITTED_STATUSES = %w[approved refunded error].freeze

  has_one :payment, class_name: 'Payment', as: :monetizable, dependent: :destroy, required: true

  validates :status, presence: true, inclusion: { in: PERMITTED_STATUSES }
  validates :payment, presence: true
  validate :validate_amount_within_authoeized_limit, on: :create, if: -> { reference_transaction.present? && payment.present? }

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

  def validate_amount_within_authoeized_limit
    authorized_amount = reference_transaction.amount
    current_approved_charge_transaction = reference_transaction.child_charge_transactions.approved
    current_charged_amount = Payment.where(
      monetizable_type: 'Transaction',
      monetizable_id: current_approved_charge_transaction.ids
    ).pluck(:amount).sum

    return if self.amount <= (authorized_amount - current_charged_amount)

    errors.add(:base, 'Amount exceeding the authorized amount')

  end
end
