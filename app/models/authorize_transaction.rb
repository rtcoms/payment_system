class AuthorizeTransaction < Transaction
  PERMITTED_STATUSES = %w[approved refunded reversed].freeze

  has_one :payment, class_name: 'Payment', as: :monetizable, dependent: :destroy, required: true

  validates :status, presence: true, inclusion: { in: PERMITTED_STATUSES }
end
