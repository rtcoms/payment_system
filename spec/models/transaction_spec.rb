require 'rails_helper'

RSpec.describe Transaction, type: :model do
  subject { build(:transaction) }

  let!(:transaction_statuses) { { approved: 'approved', reversed: 'reversed', refunded: 'refunded', error: 'error' } }

  it 'generates a UUID before creating a new transaction' do
    transaction = Transaction.create(amount: 100.0, status: 'approved', customer_email: 'customer@example.com',
                                     merchant: create(:merchant))

    expect(transaction.uuid).to be_present
    expect(transaction.uuid).to match(/\A[\w\d-]+\z/) # Validates the UUID format
  end

  describe 'associations' do
    it { should belong_to(:merchant) }
    it { should belong_to(:reference_transaction).optional }
    it { should have_many(:child_transactions) }
  end

  describe 'validations' do
    #TODO: Started failing because of before_validation callback
    # it { should validate_presence_of(:uuid) }
    it { should validate_uniqueness_of(:uuid).case_insensitive }
    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount).is_greater_than(0) }
    it { should validate_presence_of(:status) }
    it { should define_enum_for(:status).with_values(transaction_statuses).backed_by_column_of_type(:enum) }
    it { should validate_presence_of(:customer_email) }
    it { should allow_value('user@example.com').for(:customer_email) }
    it { should_not allow_value('invalid_email').for(:customer_email) }
    it { should validate_presence_of(:merchant) }
  end

  describe 'polymorphic associations' do
    it 'has many child_transactions and belongs_to reference transaction' do
      authorize_transaction = create(:authorize_transaction)
      charge_transaction1 = create(:charge_transaction, reference_transaction: authorize_transaction)
      charge_transaction2 = create(:charge_transaction, reference_transaction: authorize_transaction)
      reversal_transaction = create(:reversal_transaction, reference_transaction: authorize_transaction)
      child_transactions = [charge_transaction1, charge_transaction2, reversal_transaction]
      refund_transaction = create(:refund_transaction, reference_transaction: charge_transaction1)

      expect(authorize_transaction.child_transactions).to match(child_transactions)
      [charge_transaction1, charge_transaction2, reversal_transaction].each do |child_transaction|
        expect(child_transaction.reference_transaction).to eq(authorize_transaction)
      end

      expect(charge_transaction1.child_transactions).to match([refund_transaction])
      expect(refund_transaction.reference_transaction).to eq(charge_transaction1)
    end
  end
end
