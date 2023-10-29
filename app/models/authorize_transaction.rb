class AuthorizeTransaction < Transaction
  include Transactions::WithPaymentInfo
  
  PERMITTED_STATUSES = %w[approved reversed].freeze

  has_one :payment, class_name: 'Payment', as: :monetizable, dependent: :destroy, required: false
  has_many :child_transactions, class_name: 'Transaction', foreign_key: 'reference_transaction_id'
  has_many :child_charge_transactions, -> { where(transaction_type: 'ChargeTransaction') }, class_name: 'Transaction', foreign_key: 'reference_transaction_id'

  validates :status, presence: true, inclusion: { in: PERMITTED_STATUSES }
end
