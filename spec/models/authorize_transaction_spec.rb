require 'rails_helper'

RSpec.describe AuthorizeTransaction, type: :model do
  subject { build(:authorize_transaction) }

  # before_validation sets uuid
  # it { should validate_presence_of(:uuid) }
  it { should validate_uniqueness_of(:uuid).case_insensitive }
  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:customer_email) }
  it { should allow_value('user@example.com').for(:customer_email) }
  it { should_not allow_value('invalid_email').for(:customer_email) }
  it { should validate_presence_of(:merchant) }

  it { should have_one(:payment).dependent(:destroy).required }

  describe 'validations' do
    context 'permitted statuses' do
      it 'is invalid if reference_transaction is not in valid state' do
        transaction = build(:authorize_transaction, status: 'error')

        expect(transaction).not_to be_valid
        expect(transaction.errors[:status]).to include('is not included in the list')
      end
    end
  end
end
