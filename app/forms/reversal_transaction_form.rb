class ReversalTransactionForm < Reform::Form
  property :reference_transaction_id
  validates :reference_transaction_id, presence: true
end