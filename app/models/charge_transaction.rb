class ChargeTransaction < Transaction
  include Transactions::WithReferenceTransaction

  private

  def valid_reference_transaction?
    reference_transaction.is_a?(valid_reference_transaction_type)
  end

  def valid_reference_transaction_type
    AuthorizeTransaction
  end
end
