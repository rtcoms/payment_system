# == Schema Information
#
# Table name: users
#
#  id                    :bigint           not null, primary key
#  email                 :string           default(""), not null
#  encrypted_password    :string           default(""), not null
#  remember_created_at   :datetime
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  status                :enum             default("active"), not null
#  name                  :string           not null
#  description           :text
#  total_transaction_sum :decimal(, )      default(0.0), not null
#  user_type             :string           default("Merchant"), not null
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
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
