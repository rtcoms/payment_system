class Transaction < ApplicationRecord
  include Discard::Model
  
  self.inheritance_column = :transaction_type
  attr_accessor :txn_amount

  enum status: { approved: 'approved', reversed: 'reversed', refunded: 'refunded', error: 'error' }

  belongs_to :merchant
  belongs_to :reference_transaction, class_name: 'Transaction', optional: true
  has_many :child_transactions, class_name: 'Transaction', foreign_key: 'reference_transaction_id'
  has_many :child_charge_transactions, -> { where(transaction_type: 'ChargeTransaction') }, class_name: 'Transaction', foreign_key: 'reference_transaction_id'

  has_one :payment, class_name: 'Payment', as: :monetizable, dependent: :destroy, inverse_of: :monetizable

  validates :uuid, presence: true, uniqueness: { case_sensitive: false }
  validates :transaction_type, presence: true
  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :customer_email, presence: true, email: true
  validates :merchant, presence: true

  before_validation :generate_uuid, on: :create
  before_validation :set_merchant, on: :create, if: -> { !merchant.present? && reference_transaction.present? }

  delegate :amount, to: :payment

  private

  def generate_uuid
    # TODO: This may generate duplicate uuid
    self.uuid ||= SecureRandom.uuid
  end

  def set_merchant
    self.merchant_id = reference_transaction.merchant_id
  end
end
