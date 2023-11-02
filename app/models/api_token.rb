# == Schema Information
#
# Table name: api_tokens
#
#  id          :bigint           not null, primary key
#  merchant_id :integer          not null
#  token       :uuid             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class ApiToken < ApplicationRecord
  belongs_to :merchant

  validates :merchant_id, presence: true, uniqueness: true
  validates :merchant, presence: true
end
