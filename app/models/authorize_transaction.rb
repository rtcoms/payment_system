class AuthorizeTransaction < Transaction
  include Transactions::WithPaymentInfo
  
  PERMITTED_STATUSES = %w[approved refunded reversed].freeze

  has_one :payment, class_name: 'Payment', as: :monetizable, dependent: :destroy, required: false

  validates :status, presence: true, inclusion: { in: PERMITTED_STATUSES }
end
