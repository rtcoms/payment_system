require 'rails_helper'
require_relative 'shared/validate_reference_transaction_spec'

RSpec.describe ChargeTransaction, type: :model do
  subject { build(:charge_transaction) }

  it { should belong_to(:merchant) }
  it { should have_one(:payment).dependent(:destroy).required }
  # it { should validate_inclusion_of(:status).in_array(%w[approved refunded error]).with_message('is not included in the list') }

  it_behaves_like 'validate_reference_transaction'

  describe 'validations' do
    context 'permitted statuses' do
      it 'is invalid if status is not in the permitted statuses list' do
        transaction = build(:charge_transaction, status: 'reversed')

        expect(transaction).not_to be_valid
        expect(transaction.errors[:status]).to include('is not included in the list')
      end
    end

    context 'reference transaction statuses' do
      it 'is invalid if status is not in the permitted statuses list' do
        transaction = build(:charge_transaction, reference_transaction: create(:authorize_transaction, status: 'reversed'))

        expect(transaction).not_to be_valid
        expect(transaction.errors[:reference_transaction]).to include('must be in one of the following state: approved')
      end
    end
  end
end
