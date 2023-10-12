# app/models/concerns/transactions/with_reference_transaction.rb
module Transactions
  module WithPaymentInfo
    extend ActiveSupport::Concern

    included do
      after_commit :create_payment, on: :create, if: -> {  (payment.present? && payment.amount == 0) || (!payment.present? && txn_amount.present?) }
    end

    private

    def create_payment
      Payment.create!(amount: txn_amount, monetizable: self)
    end
  end
end
