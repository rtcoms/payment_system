require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }
  let!(:user_statuses) { { active: 'active', inactive: 'inactive' } }

  context 'validations' do
    it { should validate_presence_of(:encrypted_password) }
    it { should validate_presence_of(:name) }
    it { should define_enum_for(:status).with_values(user_statuses).backed_by_column_of_type(:enum) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should allow_value('user@example.com').for(:email) }
    it { should_not allow_value('invalid_email').for(:email) }
  end

  describe '.create_merchant' do
    it 'creates a new merchant user' do
      merchant_params = {
        name: 'Merchant Name',
        email: 'merchant@example.com',
        encrypted_password: 'password',
        status: 'active',
        total_transaction_sum: 0
      }

      expect do
        User.create_merchant(merchant_params)
      end.to change(Merchant, :count).by(1)
    end
  end

  describe '.create_admin' do
    it 'creates a new admin user' do
      admin_params = {
        name: 'Admin Name',
        email: 'admin@example.com',
        encrypted_password: 'password',
        status: 'active',
        total_transaction_sum: 0
      }

      expect do
        User.create_admin(admin_params)
      end.to change(Admin, :count).by(1)
    end
  end
end
