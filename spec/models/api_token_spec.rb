require 'rails_helper'

RSpec.describe ApiToken, type: :model do
  subject { build(:api_token) }

  it { should belong_to(:merchant) }
  it { should validate_presence_of(:merchant_id) }
  it { should validate_uniqueness_of(:merchant_id) }
  it { should validate_presence_of(:merchant) }
end
