class AuthorizeTransactionForm < Reform::Form
  property :merchant_id
  property :customer_email
  property :customer_phone

  property :payment do
    property :amount

    validates :amount, presence: true
  end

  validates :merchant_id, presence: true
  validates :customer_email, presence: true
end