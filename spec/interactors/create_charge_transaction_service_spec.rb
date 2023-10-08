# spec/interactors/create_authorize_transaction_service_spec.rb
require 'rails_helper'

RSpec.describe CreateChargeTransactionService do
  describe '.call' do
    let!(:active_merchant) { create(:merchant, status: :active) }
    let!(:inactive_merchant) { create(:merchant, status: :inactive) }
    let!(:authorize_transaction) { create(:authorize_transaction, amount: 100) }

    context 'when valid parameters are provided' do
      let!(:valid_params) do
        {
            merchant_id: active_merchant.id,
            reference_transaction_id: authorize_transaction.id,
            customer_email: 'test@example.com',
            customer_phone: '1234567890',
            txn_amount: 100
        }
      end

      it 'creates an ChargeTransaction' do
        # result = described_class.call(transaction_params: valid_params)
        expect do
          described_class.call(transaction_params: valid_params, transaction_type: :charge_transaction)
        end.to change(ChargeTransaction, :count).by(1)
        # expect(result).to be_success
      end

      # it 'calls the interactors' do
      #   expect(ValidateTransactionParams).to receive(:call!).ordered
      #   expect(ValidateMerchant).to receive(:call!).ordered
      #   described_class.call
      # end
    end

    context 'when invalid parameters are provided' do
      let(:invalid_params) do
        {
          reference_transaction_id: authorize_transaction.id,
          merchant_id: active_merchant.id,
          customer_email: 'asd@asd.com',
          customer_phone: '1234567890',
          txn_amount: nil
        }
      end

      it 'fails and provides error messages' do
        result = described_class.call(transaction_params: invalid_params, transaction_type: :charge_transaction)

        expect(result).to be_failure
        expect(result.message).to include("Txn amount can't be blank")
      end
    end

    context 'when reference transaction is not present' do
      let(:invalid_params) do
        {
          merchant_id: active_merchant.id,
          customer_email: 'test@example.com',
          customer_phone: '1234567890',
          txn_amount: 100 
        }
      end

      before do
        allow(Merchant).to receive(:find_by).with(id: 1).and_return(nil)
      end

      it 'fails and provides error messages' do
        result = described_class.call(transaction_params: invalid_params, transaction_type: :charge_transaction)

        expect(result).to be_failure
        expect(result.message).to include("Reference transaction can't be blank")
      end
    end
  end
end
