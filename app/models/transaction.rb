require 'securerandom'
class Transaction < ApplicationRecord
  UUID_GENERATION_MAX_ATTEMPTS = 5

  self.inheritance_column = :transaction_type

  enum status: { approved: 'approved', reversed: 'reversed', refunded: 'refunded', error: 'error' }

  belongs_to :merchant
  has_many :child_transactions, as: :reference_transaction, class_name: 'Transaction'
  belongs_to :reference_transaction, polymorphic: true, optional: true, foreign_type: :transaction_type

  validates :uuid, presence: true, uniqueness: { case_sensitive: false }
  validates :transaction_type, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :customer_email, presence: true, email: true
  validates :merchant, presence: true

  before_validation :generate_uuid, on: :create

  private

  def generate_uuid
    # TODO: This may generate duplicate uuid
    self.uuid ||= SecureRandom.uuid
  end
end
