class ChargeTransaction < Transaction
  include Transactions::WithReferenceTransaction
  include Transactions::WithPaymentInfo

  PERMITTED_STATUSES = %w[approved refunded error].freeze

  has_one :payment, class_name: 'Payment', as: :monetizable, dependent: :destroy, required: false
  has_many :child_transactions, class_name: 'Transaction', foreign_key: 'reference_transaction_id'

  validates :status, presence: true, inclusion: { in: PERMITTED_STATUSES }
  validate :validate_amount_within_authorized_limit, on: :create, if: Proc.new {|obj| obj.reference_transaction.present? && obj.txn_amount.present? }

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

  def validate_amount_within_authorized_limit
    authorized_amount = reference_transaction.amount
    current_approved_charge_transaction = reference_transaction.child_charge_transactions.approved
    Rails.logger.info "==========authorized_amount: #{authorized_amount}"
    current_charged_amount = Payment.where(monetizable_type: 'Transaction', monetizable_id: current_approved_charge_transaction.ids).pluck(:amount).sum

    return if (self.txn_amount) <= (authorized_amount - current_charged_amount)

    errors.add(:base, 'Amount exceeding the authorized amount')
    false
  end
end
