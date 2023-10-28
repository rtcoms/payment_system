class ApiToken < ApplicationRecord
  belongs_to :merchant

  validates :merchant_id, presence: true, uniqueness: true
  validates :merchant, presence: true
end
