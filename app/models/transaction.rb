class Transaction < ApplicationRecord
  self.inheritance_column = :transaction_type

  enum status: { approved: 'approved', reversed: 'reversed', refunded: 'refunded', error: 'error' }

  belongs_to :merchant
  belongs_to :reference_transaction, class_name: 'Transaction', optional: true
  has_many :child_transactions, class_name: 'Transaction', foreign_key: 'reference_transaction_id'
  has_one :payment, class_name: 'Payment', as: :monetizable, dependent: :destroy

  validates :uuid, presence: true, uniqueness: { case_sensitive: false }
  validates :transaction_type, presence: true
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
