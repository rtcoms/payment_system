# == Schema Information
#
# Table name: transactions
#
#  id                       :bigint           not null, primary key
#  uuid                     :uuid             not null
#  status                   :enum             default("approved"), not null
#  customer_email           :string           not null
#  customer_phone           :string
#  merchant_id              :bigint           not null
#  reference_transaction_id :bigint
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  transaction_type         :string           default("Transaction"), not null
#  discarded_at             :datetime
#
class RefundTransaction < Transaction
  include Transactions::WithReferenceTransaction
  include Transactions::WithPaymentInfo

  PERMITTED_STATUSES = %w[approved error].freeze

  has_one :payment, class_name: 'Payment', as: :monetizable, dependent: :destroy, required: false

  validates :status, presence: true, inclusion: { in: PERMITTED_STATUSES }
  validate :validate_amount_matches_with_reference_transaction, if: -> { payment.present? && reference_transaction.present? }

  # after_commit :create_payment, on: :create, if: -> { !payment.present? && txn_amount.present? }

  private

  def valid_reference_transaction?
    reference_transaction.is_a?(valid_reference_transaction_type)
  end

  def valid_reference_transaction_type
    ChargeTransaction
  end

  def valid_statuses_for_reference_transaction
    # ChargeTransaction would be reference transactino here
    %w[approved]
  end

  # def create_payment
  #   Payment.create!(amount: txn_amount, monetizable: self)
  # end

  def validate_amount_matches_with_reference_transaction
    return if self.amount == reference_transaction.amount

    errors.add(:base, 'Amount must be equalt to charged transaction')
  end
end
