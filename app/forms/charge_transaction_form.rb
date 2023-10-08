class ChargeTransactionForm < Reform::Form
  property :reference_transaction_id
  property :merchant_id
  property :customer_email
  property :customer_phone
  property :txn_amount

  validates :reference_transaction_id, presence: true
  validates :txn_amount, presence: true
end