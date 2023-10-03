class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  self.inheritance_column = :user_type

  devise :database_authenticatable

  enum status: { active: 'active', inactive: 'inactive' }, _suffix: true, _prefix: true

  validates :encrypted_password, presence: true
  validates :name, presence: true
  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :total_transaction_sum, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :email, presence: true, uniqueness: true, email: true
end
