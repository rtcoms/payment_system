require 'rails_helper'
require_relative 'shared/validate_reference_transaction_spec'

RSpec.describe RefundTransaction, type: :model do
  subject { build(:refund_transaction) }

  it { should belong_to(:merchant) }
  it { should have_one(:payment).dependent(:destroy).optional }

  it_behaves_like 'validate_reference_transaction'

  describe 'validations' do
    context 'permitted statuses' do
      it 'is invalid if status is not in the permitted statuses list' do
        transaction = build(:refund_transaction, status: 'refunded')

        expect(transaction).not_to be_valid
        expect(transaction.errors[:status]).to include('is not included in the list')
      end
    end

    context 'reference transaction statuses' do
      it 'is invalid if reference_transaction is not in valid state' do
        transaction = build(:refund_transaction, reference_transaction: create(:charge_transaction, status: 'refunded'))

        expect(transaction).not_to be_valid
        expect(transaction.errors[:reference_transaction]).to include('must be in one of the following state: approved')
      end
    end
  end
end
