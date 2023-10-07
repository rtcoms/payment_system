# spec/support/shared_examples/validate_reference_transaction_shared_example.rb
RSpec.shared_examples 'validate_reference_transaction' do
  it { should belong_to(:reference_transaction).class_name('Transaction') }
  it { should validate_presence_of(:reference_transaction) }

  it 'validates reference_transaction on create if reference_transaction is present' do
    if subject.reference_transaction.present?
      expect(subject.reference_transaction.transaction_type).to eq(subject.send(:valid_reference_transaction_type).name)
    end
  end

  it 'validates reference_transaction_approved on create if reference_transaction is present' do
    expect(subject.reference_transaction).to be_approved if subject.reference_transaction.present?
  end
end
