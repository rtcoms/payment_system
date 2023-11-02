# Reform form class for reversal transaction type
# @attr [Integer] reference_transaction_id tranaction id of authorization transaction for which charge is applicable
# @attr [Integer] merchant_id
# @attr [String] customer_email
# @attr [String] customer_phone
# @attr [Float] txn_amount

class ReversalTransactionForm < Reform::Form
  property :reference_transaction_id
  property :merchant_id
  property :customer_email
  property :customer_phone

  validates :reference_transaction_id, presence: true
end