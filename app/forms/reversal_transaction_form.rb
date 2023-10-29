class ReversalTransactionForm < Reform::Form
  property :reference_transaction_id
  property :merchant_id
  property :customer_email
  property :customer_phone

  validates :reference_transaction_id, presence: true
end