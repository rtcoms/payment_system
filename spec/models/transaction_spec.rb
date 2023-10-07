require 'rails_helper'

RSpec.describe Transaction, type: :model do
  subject { build(:transaction) }
  let!(:transaction_statuses) { { approved: 'approved', reversed: 'reversed', refunded: 'refunded', error: 'error' } }

  describe 'associations' do
    it { should belong_to(:merchant) }
    it { should belong_to(:reference_transaction).class_name('Transaction').optional }
    it { should have_many(:child_transactions).class_name('Transaction').with_foreign_key('reference_transaction_id') }
    it { should have_one(:payment).dependent(:destroy).optional }
  end

  describe 'validations' do
    # uuid is set in before_validation
    # it { should validate_presence_of(:uuid) }
    it { should validate_uniqueness_of(:uuid).case_insensitive }
    it { should validate_presence_of(:status) }
    it { should define_enum_for(:status).with_values(transaction_statuses).backed_by_column_of_type(:enum) }
    it { should validate_presence_of(:customer_email) }
    it { should allow_value('user@example.com').for(:customer_email) }
    it { should_not allow_value('invalid_email').for(:customer_email) }
    it { should validate_presence_of(:merchant) }
  end

  describe 'associations' do
    it 'associates with a merchant' do
      merchant = create(:merchant)
      transaction = create(:transaction, merchant: merchant)

      expect(transaction.merchant).to eq(merchant)
    end

    it 'associates with a reference_transaction' do
      authorize_transaction = create(:authorize_transaction) 
      charge_transaction1 = create(:charge_transaction, reference_transaction: authorize_transaction)
      charge_transaction2 = create(:charge_transaction, reference_transaction: authorize_transaction)
      refund_transaction = create(:refund_transaction, reference_transaction: charge_transaction1)

      expect(authorize_transaction.reference_transaction).to eq(nil)
      expect(charge_transaction1.reference_transaction).to eq(authorize_transaction)
      expect(charge_transaction2.reference_transaction).to eq(authorize_transaction)
      expect(refund_transaction.reference_transaction).to eq(charge_transaction1)

      expect(authorize_transaction.child_transactions).to match([charge_transaction1, charge_transaction2])
      expect(charge_transaction1.child_transactions).to match([refund_transaction])
      expect(charge_transaction2.child_transactions).to match([])
      expect(refund_transaction.child_transactions).to match([])
    end
  end
end
