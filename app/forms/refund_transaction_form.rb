# Reform form class for refund transaction type
# @attr [Integer] reference_transaction_id tranaction id of charge transaction for which charge is applicable
# @attr [Integer] merchant_id
# @attr [String] customer_email
# @attr [String] customer_phone
# @attr [Float] txn_amount

class RefundTransactionForm < Reform::Form
  property :reference_transaction_id
  property :merchant_id
  property :customer_email
  property :customer_phone
  property :txn_amount

  validates :reference_transaction_id, presence: true
  validates :txn_amount, presence: true
end