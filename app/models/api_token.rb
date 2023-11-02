# == Schema Information
#
# Table name: api_tokens
#
# @!attribute id
#   @return []
# @!attribute merchant_id
#   @return [Integer]
# @!attribute token
#   @return [String]
# @!attribute created_at
#   @return [Time]
# @!attribute updated_at
#   @return [Time]
#
# Unique api token for each merchant
class ApiToken < ApplicationRecord
  belongs_to :merchant

  validates :merchant_id, presence: true, uniqueness: true
  validates :merchant, presence: true
end
