class Payment < ApplicationRecord
  belongs_to :monetizable, polymorphic: true, touch: true, optional: true

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :monetizable, presence: true

  # before_validation :set_monetizable

  # private

  # def set_monetizable
  #   binding.pry
  #   a =5
  #   b = 6
  # end
end
