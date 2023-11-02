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
class ReversalTransaction < Transaction
  include Transactions::WithReferenceTransaction

  PERMITTED_STATUSES = %w[approved error].freeze

  validates :status, presence: true, inclusion: { in: PERMITTED_STATUSES }

  private

  def valid_reference_transaction?
    reference_transaction.is_a?(valid_reference_transaction_type)
  end

  def valid_reference_transaction_type
    AuthorizeTransaction
  end

  def valid_statuses_for_reference_transaction
    # AuthorizeTransaction would be reference transactino ehre
    %w[approved]
  end
end
