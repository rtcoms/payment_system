# spec/interactors/create_authorize_transaction_service_spec.rb
require 'rails_helper'

RSpec.describe CreateAuthorizeTransactionService do
  describe '.call' do
    context 'when valid parameters are provided' do
      let(:valid_params) do
        {
          authorize_transaction_params: {
            merchant_id: 1,
            customer_email: 'test@example.com',
            customer_phone: '1234567890',
            payment: { amount: 100 }
          }
        }
      end

      it 'creates an AuthorizeTransaction' do
        result = described_class.call(valid_params)

        expect(result).to be_success
      end
    end

    context 'when invalid parameters are provided' do
      let(:invalid_params) do
        {
          authorize_transaction_params: {
            merchant_id: 1,
            customer_email: 'asd@asd.com',
            customer_phone: '1234567890',
            payment: { amount: nil }
          }
        }
      end

      it 'fails and provides error messages' do
        result = described_class.call(invalid_params)

        expect(result).to be_failure
        expect(result.message).to include("Amount can't be blank")
      end
    end
  end
end
