class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  self.inheritance_column = :user_type

  devise :database_authenticatable

  enum status: { active: 'active', inactive: 'inactive' }

  validates :encrypted_password, presence: true
  validates :name, presence: { allow_nil: false}
  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :total_transaction_sum, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, email: true

  def self.create_merchant(user_attributes)
    Merchant.create(user_attributes)
  end

  def self.create_admin(user_attributes)
    Admin.create(user_attributes)
  end
end
