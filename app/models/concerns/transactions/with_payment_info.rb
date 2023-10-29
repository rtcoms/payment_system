module Transactions
  module WithPaymentInfo
    extend ActiveSupport::Concern

    included do
      has_one :payment, class_name: 'Payment', as: :monetizable, dependent: :destroy, inverse_of: :monetizable

      after_commit :create_payment, on: :create, if: -> { (payment.present? && payment.amount == 0) || (!payment.present? && txn_amount.present?) }
    end

    private

    def create_payment
      Payment.create!(amount: txn_amount, monetizable: self)
    end
  end
end
