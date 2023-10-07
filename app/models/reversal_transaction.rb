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
