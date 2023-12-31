# spec/interactors/create_authorize_transaction_service_spec.rb
require 'rails_helper'

RSpec.describe CreateAuthorizeTransactionService do
  describe '.call' do
    let!(:active_merchant) { create(:merchant, status: :active) }
    let!(:inactive_merchant) { create(:merchant, status: :inactive) }

    context 'when valid parameters are provided' do
      let!(:valid_params) do
        {
            merchant_id: active_merchant.id,
            customer_email: 'test@example.com',
            customer_phone: '1234567890',
            txn_amount: 100
        }
      end

      it 'creates an AuthorizeTransaction' do
        # result = described_class.call(transaction_params: valid_params)
        expect do
          described_class.call(transaction_params: valid_params, transaction_type: :authorize_transaction)
        end.to change(AuthorizeTransaction, :count).by(1).and change { Payment.count }.by(1)
        # expect(result).to be_success
      end

      # it 'calls the interactors' do
      #   expect(ValidateTransactionParams).to receive(:call!).ordered
      #   expect(ValidateMerchant).to receive(:call!).ordered
      #   described_class.call(transaction_params: valid_params, transaction_type: :authorize_transaction)
      # end
    end

    context 'when invalid parameters are provided' do
      let!(:invalid_params) do
        {
          merchant_id: active_merchant.id,
          customer_email: 'asd@asd.com',
          customer_phone: '1234567890',
          txn_amount: nil
        }
      end

      it 'fails and provides error messages' do
        result = described_class.call(transaction_params: invalid_params, transaction_type: :authorize_transaction)

        expect(result).to be_failure
        expect(result.message).to include("Txn amount can't be blank")
      end
    end

    context 'when merchant is not present' do
      let!(:invalid_params) do
        {
          merchant_id: 1,
          customer_email: 'test@example.com',
          customer_phone: '1234567890',
          txn_amount: 100
        }
      end

      before do
        allow(Merchant).to receive(:find_by).with(id: 1).and_return(nil)
      end

      it 'fails and provides error messages' do
        result = described_class.call(transaction_params: invalid_params, transaction_type: :authorize_transaction)

        expect(result).to be_failure
        expect(result.message).to include('Merchant is not present')
      end
    end
  end
end
