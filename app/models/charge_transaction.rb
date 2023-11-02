# == Schema Information
#
# Table name: transactions
#
# @!attribute id
#   @return []
# @!attribute uuid
#   @return [String]
# @!attribute status
#   @return []
# @!attribute customer_email
#   @return [String]
# @!attribute customer_phone
#   @return [String]
# @!attribute merchant_id
#   @return []
# @!attribute reference_transaction_id
#   @return []
# @!attribute created_at
#   @return [Time]
# @!attribute updated_at
#   @return [Time]
# @!attribute transaction_type
#   @return [String]
# @!attribute discarded_at
#   @return [Time]
#
# Charge Transaction is created with default status approved for an approved AuthorizeTransaction it the sum of amount of all approved charge transactions
# associated with  a authorize transaction must be <= authorized amount. When a RefundTransaction is created for ChargETransaction 
# its status is changed ti 'refunded'
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

  # ChargeTransaction can only be create in reference with an AuthorizeTransaction
  def valid_reference_transaction_type
    AuthorizeTransaction
  end

  # ChargeTransaction can only be created for an approved AuthorizeTransaction
  def valid_statuses_for_reference_transaction
    %w[approved]
  end

  # Validates that sum of Charged amount for an authorize transaction must be <= authorized amount
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
