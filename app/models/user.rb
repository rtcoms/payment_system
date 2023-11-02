# == Schema Information
#
# Table name: users
#
# @!attribute id
#   @return []
# @!attribute email
#   @return [String]
# @!attribute encrypted_password
#   @return [String]
# @!attribute remember_created_at
#   @return [Time]
# @!attribute created_at
#   @return [Time]
# @!attribute updated_at
#   @return [Time]
# @!attribute status
#   @return []
# @!attribute name
#   @return [String]
# @!attribute description
#   @return [String]
# @!attribute total_transaction_sum
#   @return []
# @!attribute user_type
#   @return [String]
#
class User < ApplicationRecord
  self.inheritance_column = :user_type

  devise :database_authenticatable

  enum status: { active: 'active', inactive: 'inactive' }

  validates :encrypted_password, presence: true
  validates :name, presence: { allow_nil: false}
  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, email: true

  def self.create_merchant(user_attributes)
    Merchant.create(user_attributes)
  end

  def self.create_admin(user_attributes)
    Admin.create(user_attributes)
  end
end
