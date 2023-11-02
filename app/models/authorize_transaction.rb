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
class AuthorizeTransaction < Transaction
  include Transactions::WithPaymentInfo
  
  PERMITTED_STATUSES = %w[approved reversed].freeze

  has_one :payment, class_name: 'Payment', as: :monetizable, dependent: :destroy, required: false
  has_many :child_transactions, class_name: 'Transaction', foreign_key: 'reference_transaction_id'
  has_many :child_charge_transactions, -> { where(transaction_type: 'ChargeTransaction') }, class_name: 'Transaction', foreign_key: 'reference_transaction_id'

  validates :status, presence: true, inclusion: { in: PERMITTED_STATUSES }
end
