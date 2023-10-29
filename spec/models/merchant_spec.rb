require 'rails_helper'

RSpec.describe Merchant, type: :model do
  context 'validations' do
    it { should have_one(:api_token) }
    it { should validate_presence_of(:total_transaction_sum) }
    it { should validate_numericality_of(:total_transaction_sum).is_greater_than_or_equal_to(0) }

    it 'is valid with valid attributes' do
      merchant = build(:merchant)
      expect(merchant).to be_valid
    end
  end
  
  context 'api token setup' do
    it 'should create api token on creation' do
      expect do
        create(:merchant)
      end.to change(ApiToken, :count).by(1)
    end
  end
end

