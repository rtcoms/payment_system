# == Schema Information
#
# Table name: transactions
#
# @!attribute id
#   @return []
# @!attribute uuid
#   @return [String]
# @!attribute status
#   @return []
# @!attribute customer_email
#   @return [String]
# @!attribute customer_phone
#   @return [String]
# @!attribute merchant_id
#   @return []
# @!attribute reference_transaction_id
#   @return []
# @!attribute created_at
#   @return [Time]
# @!attribute updated_at
#   @return [Time]
# @!attribute transaction_type
#   @return [String]
# @!attribute discarded_at
#   @return [Time]
#
class Transaction < ApplicationRecord
  include Discard::Model
  class Type
    CHARGE = 'charge'.freeze
    REFUND = 'refund'.freeze
    AUTHORIZE = 'authorize'.freeze
    REVERSAL = 'reversal'.freeze

    ALL = [AUTHORIZE, CHARGE, REFUND, REVERSAL].freeze
  end
  
  self.inheritance_column = :transaction_type
  attr_accessor :txn_amount

  enum status: { approved: 'approved', reversed: 'reversed', refunded: 'refunded', error: 'error' }

  belongs_to :merchant

  validates :uuid, presence: true, uniqueness: { case_sensitive: false }
  validates :transaction_type, presence: true
  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :customer_email, presence: true, email: true
  validates :merchant, presence: true

  before_validation :generate_uuid, on: :create

  delegate :amount, to: :payment

  private

  def generate_uuid
    self.uuid ||= SecureRandom.uuid
  end

  
end
