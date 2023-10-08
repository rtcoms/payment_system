class RefundTransactionForm < Reform::Form
  property :reference_transaction_id
  property :payment do
    property :amount

    validates :amount, presence: true
  end
  validates :reference_transaction_id, presence: true
end