# == Schema Information
#
# Table name: payments
#
#  id               :bigint           not null, primary key
#  amount           :decimal(, )
#  monetizable_type :string           not null
#  monetizable_id   :bigint           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
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
