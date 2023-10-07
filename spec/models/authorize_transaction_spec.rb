require 'rails_helper'

RSpec.describe AuthorizeTransaction, type: :model do
  subject { build(:authorize_transaction) }

  it { should validate_presence_of(:uuid) }
  it { should validate_uniqueness_of(:uuid).case_insensitive }
  it { should validate_presence_of(:amount) }
  it { should validate_numericality_of(:amount).is_greater_than(0) }
  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:customer_email) }
  it { should allow_value('user@example.com').for(:customer_email) }
  it { should_not allow_value('invalid_email').for(:customer_email) }
  it { should validate_presence_of(:merchant) }
end
