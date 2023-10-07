class Payment < ApplicationRecord
  belongs_to :monetizable, polymorphic: true, optional: false

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :monetizable, presence: true
end
