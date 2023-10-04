class Transaction < ApplicationRecord
  enum status: { approved: 'approved', reversed: 'reversed', refunded: 'refunded', error: 'error' }

  belongs_to :merchant
  belongs_to :reference_transaction, class_name: 'Transaction', optional: true

  validates :uuid, presence: true, uniqueness: { case_sensitive: false }
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :customer_email, presence: true, email: true
  validates :merchant, presence: true
end
