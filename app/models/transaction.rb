# == Schema Information
#
# Table name: transactions
#
#  id                       :bigint           not null, primary key
#  uuid                     :uuid             not null
#  status                   :enum             default("approved"), not null
#  customer_email           :string           not null
#  customer_phone           :string
#  merchant_id              :bigint           not null
#  reference_transaction_id :bigint
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  transaction_type         :string           default("Transaction"), not null
#  discarded_at             :datetime
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
    # TODO: This may generate duplicate uuid
    self.uuid ||= SecureRandom.uuid
  end

  
end
