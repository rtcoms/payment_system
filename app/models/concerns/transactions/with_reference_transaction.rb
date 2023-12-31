# This module provide association with reference_transaction and validation of 
# reference transaction type and status

module Transactions
  module WithReferenceTransaction
    extend ActiveSupport::Concern

    included do
      belongs_to :reference_transaction, class_name: 'Transaction', optional: false

      validates :reference_transaction, presence: true
      validate :validate_reference_transaction, if: -> { reference_transaction.present? }
      validate :validate_reference_transaction_status, on: :create, if: -> { reference_transaction.present? }

      before_validation :set_merchant, on: :create, if: -> { merchant.blank? && reference_transaction.present? }
    end

    private

    def validate_reference_transaction
      return if valid_reference_transaction?

      errors.add(:reference_transaction, "must be of type #{reference_transaction.valid_reference_transaction_type}")
    end

    def validate_reference_transaction_status
      return if valid_statuses_for_reference_transaction.include?(reference_transaction.status)

      errors.add(:reference_transaction, 'must be approved or refunded')
    end

    def valid_reference_transaction?
      raise NotImplementedError, 'Subclasses must implement valid_reference_transaction?'
    end

    def valid_reference_transaction_type
      raise NotImplementedError, 'Subclasses must implement valid_reference_transaction_type'
    end

    def valid_statuses_for_reference_transaction
      raise NotImplementedError, 'Subclasses must implement valid_statuses_for_reference_transaction?'
    end

    # Set merchant_id from reference transaction
    def set_merchant
      self.merchant_id = reference_transaction.merchant_id
    end
  end
end
