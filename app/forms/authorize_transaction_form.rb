# Reform form class for authorize transaction type
# @attr [Integer] merchant_id
# @attr [String] customer_email
# @attr [String] customer_phone
# @attr [Float] txn_amount
class AuthorizeTransactionForm < Reform::Form
  property :merchant_id
  property :customer_email
  property :customer_phone
  property :txn_amount

  validates :merchant_id, presence: true
  validates :txn_amount, presence: true
  validates :customer_email, presence: true
end