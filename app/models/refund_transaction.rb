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
# A Refund transaction is created for a ChargeTransaction to mark ChargeTransaction as refunded
class RefundTransaction < Transaction
  include Transactions::WithReferenceTransaction
  include Transactions::WithPaymentInfo

  PERMITTED_STATUSES = %w[approved error].freeze

  has_one :payment, class_name: 'Payment', as: :monetizable, dependent: :destroy, required: false

  validates :status, presence: true, inclusion: { in: PERMITTED_STATUSES }
  validate :validate_amount_matches_with_reference_transaction, if: -> { payment.present? && reference_transaction.present? }
  private

  def valid_reference_transaction?
    reference_transaction.is_a?(valid_reference_transaction_type)
  end

  # RefundTransaction can only be created for a ChargeTransaction
  def valid_reference_transaction_type
    ChargeTransaction
  end

  # Refund transaction must be created only for an approved ChargeTransaction
  def valid_statuses_for_reference_transaction
    %w[approved]
  end


  # Validates that amount or RefundTransaction matches ChargeTransaction amount
  def validate_amount_matches_with_reference_transaction
    return if self.amount == reference_transaction.amount

    errors.add(:base, 'Amount must be equalt to charged transaction')
  end
end
