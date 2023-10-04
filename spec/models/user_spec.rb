require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }
  let!(:user_statuses) { { active: 'active', inactive: 'inactive' } }

  context 'validations' do
    it { should validate_presence_of(:encrypted_password) }
    it { should validate_presence_of(:name) }
    it { should define_enum_for(:status).with_values(user_statuses).backed_by_column_of_type(:enum) }
    it { should validate_presence_of(:total_transaction_sum) }
    it { should validate_numericality_of(:total_transaction_sum).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should allow_value('user@example.com').for(:email) }
    it { should_not allow_value('invalid_email').for(:email) }
  end
end
