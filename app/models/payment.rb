# == Schema Information
#
# Table name: payments
#
# @!attribute id
#   @return []
# @!attribute amount
#   @return []
# @!attribute monetizable_type
#   @return [String]
# @!attribute monetizable_id
#   @return []
# @!attribute created_at
#   @return [Time]
# @!attribute updated_at
#   @return [Time]
#
class Payment < ApplicationRecord
  belongs_to :monetizable, polymorphic: true, touch: true
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
