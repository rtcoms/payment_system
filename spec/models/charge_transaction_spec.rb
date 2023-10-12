require 'rails_helper'
require_relative 'shared/validate_reference_transaction_spec'

RSpec.describe ChargeTransaction, type: :model do
  subject { build(:charge_transaction) }

  it { should belong_to(:merchant) }
  it { should have_one(:payment).dependent(:destroy).optional }
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
        expect(transaction.errors[:reference_transaction]).to include('must be approved or refunded')
      end
    end
  end

  describe 'validate_amount_within_authoeized_limit' do
    context 'when the charged amount is within the authorized limit' do
      let!(:merchant) { create(:merchant) }
      let!(:authorize_transaction) { create(:authorize_transaction, txn_amount: 100) }
      let!(:charge_transaction) { create(:charge_transaction, reference_transaction: authorize_transaction, txn_amount: 50) }

      it 'passes validation' do
        authorize_transaction.reload
        charge_transaction.valid?
        expect(charge_transaction.errors[:base]).to be_empty
      end
    end

    context 'when the charged amount exceeds the authorized limit' do
      let!(:merchant) { create(:merchant) }
      let!(:authorize_transaction2) { create(:authorize_transaction, txn_amount: 100) }
      let!(:charge_transaction1) { create(:charge_transaction, reference_transaction: authorize_transaction2, txn_amount: 25) }
      let!(:charge_transaction2) { create(:charge_transaction, reference_transaction: authorize_transaction2, txn_amount: 25) }
      # let!(:invalid_charge_txn) { create(:charge_transaction, reference_transaction: authorize_transaction2, txn_amount: 60) }

      it 'fails validation' do
        # authorize_transaction2.reload
        invalid_charge_txn = build(:charge_transaction, reference_transaction: authorize_transaction2, txn_amount: 60)
        invalid_charge_txn.save

        expect(invalid_charge_txn.errors[:base]).to include('Amount exceeding the authorized amount')
      end
    end
  end
end
