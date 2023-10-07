# app/models/concerns/transactions/with_reference_transaction.rb
module Transactions
  module WithReferenceTransaction
    extend ActiveSupport::Concern

    included do
      belongs_to :reference_transaction, class_name: 'Transaction', optional: false

      validates :reference_transaction, presence: true
      validate :validate_reference_transaction, if: -> { reference_transaction.present? }
      validate :validate_reference_transaction_approved, on: :create, if: -> { reference_transaction.present? }
    end

    private

    def validate_reference_transaction
      return if valid_reference_transaction?

      errors.add(:reference_transaction, "must be of type #{reference_transaction.valid_reference_transaction_type}")
    end

    def validate_reference_transaction_approved
      return if reference_transaction.approved?

      errors.add(:reference_transaction, 'reference transaction must be in approved state')
    end

    def valid_reference_transaction?
      # Implement the logic to check if the reference_transaction is valid
      # for the specific transaction type in each child class
      raise NotImplementedError, 'Subclasses must implement valid_reference_transaction?'
    end

    def valid_reference_transaction_type
      aise NotImplementedError, 'Subclasses must implement valid_reference_transaction?'
    end
  end
end
