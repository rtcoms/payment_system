class AuthorizeTransactionForm < Reform::Form
  property :merchant_id
  property :customer_email
  property :customer_phone
  property :txn_amount

  validates :merchant_id, presence: true
  validates :txn_amount, presence: true
  validates :customer_email, presence: true
end