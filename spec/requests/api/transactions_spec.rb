require 'rails_helper'

RSpec.describe "Api::Transactions", type: :request do
  let(:api_token) { Rails.application.config.api_settings['api_token'] } # Replace with your actual API token

  before do
    @active_merchant = create(:merchant, status: :active)
    @inactive_merchant = create(:merchant, status: :inactive)
  end

  describe 'POST /api/transactions/:transaction_type' do
    context 'with valid API token' do
      before do
        @headers = {
          'Authorization' => "Bearer #{@active_merchant.api_token.token}",
          'Content-Type' => 'application/json'
        }
      end

      context 'when creating an AuthorizeTransaction' do
        let(:valid_authorize_params) do
          {
            merchant_id: @active_merchant.id,
            customer_email: 'test@example.com',
            customer_phone: '1234567890',
            txn_amount: 100
          }
        end

        it 'creates an AuthorizeTransaction' do
          post '/api/transactions/authorize', params: valid_authorize_params.to_json, headers: @headers

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)['status']).to eq('approved')
          expect(AuthorizeTransaction.count).to eq(1)
          expect(Payment.count).to eq(1)
        end

        # Add more AuthorizeTransaction test cases here
      end

      context 'when creating a ChargeTransaction' do
        before do
          @authorize_transaction = create(:authorize_transaction, txn_amount: 100, merchant: @active_merchant)
        end

        let(:valid_charge_params) do
          {
            merchant_id: @active_merchant.id,
            reference_transaction_id: @authorize_transaction.id,
            customer_email: 'test@example.com',
            customer_phone: '1234567890',
            txn_amount: 100
          }
        end

        it 'creates a ChargeTransaction' do
          post '/api/transactions/charge', params: valid_charge_params.to_json, headers: @headers

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)['status']).to eq('approved')
          expect(ChargeTransaction.count).to eq(1)
          expect(@active_merchant.reload.total_transaction_sum.to_f).to eq(100)
        end

        # Add more ChargeTransaction test cases here
      end

      context 'when creating a RefundTransaction' do
        before do
          @active_merchant_with_balance = create(:merchant, status: :active, total_transaction_sum: 50)
          @charge_transaction = create(:charge_transaction, txn_amount: 50, merchant: @active_merchant_with_balance)
          @headers = {
            'Authorization' => "Bearer #{@active_merchant_with_balance.api_token.token}",
            'Content-Type' => 'application/json'
          }
        end

        let(:valid_refund_params) do
          {
            merchant_id: @active_merchant_with_balance.id,
            reference_transaction_id: @charge_transaction.id,
            customer_email: 'test@example.com',
            customer_phone: '1234567890',
            txn_amount: 50
          }
        end

        it 'creates a RefundTransaction' do
          post '/api/transactions/refund', params: valid_refund_params.to_json, headers: @headers

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)['status']).to eq('approved')
          expect(RefundTransaction.count).to eq(1)
          expect(@active_merchant_with_balance.reload.total_transaction_sum.to_f).to eq(0)
        end

        # Add more RefundTransaction test cases here
      end

      context 'when creating a ReversalTransaction' do
        before do
          @active_merchant_with_balance = create(:merchant, status: :active, total_transaction_sum: 50)
          @authorize_transaction = create(:authorize_transaction, txn_amount: 100, merchant: @active_merchant_with_balance)
          @charge_transaction = create(:charge_transaction, txn_amount: 50, merchant: @active_merchant_with_balance)
          @headers = {
            'Authorization' => "Bearer #{@active_merchant_with_balance.api_token.token}",
            'Content-Type' => 'application/json'
          }
        end

        let(:valid_reversal_params) do
          {
            merchant_id: @active_merchant_with_balance.id,
            reference_transaction_id: @authorize_transaction.id,
            customer_email: 'test@example.com',
            customer_phone: '1234567890'
          }
        end

        it 'creates a ReversalTransaction' do
          post '/api/transactions/reversal', params: valid_reversal_params.to_json, headers: @headers

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)['status']).to eq('approved')
          expect(ReversalTransaction.count).to eq(1)
          expect(@active_merchant_with_balance.reload.total_transaction_sum.to_f).to eq(0)
        end

        # Add more ReversalTransaction test cases here
      end
    end

    context 'with invalid API token' do
      let(:valid_authorize_params) do
        {
          merchant_id: @active_merchant.id,
          customer_email: 'test@example.com',
          customer_phone: '1234567890',
          txn_amount: 100
        }
      end

      it 'returns unauthorized status' do
        headers = { 'Authorization' => 'Bearer invalid_token', 'Content-Type' => 'application/json' }

        post '/api/transactions/authorize', params: valid_authorize_params.to_json, headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with invalid transaction type' do
      let(:valid_authorize_params) do
        {
          merchant_id: @active_merchant.id,
          customer_email: 'test@example.com',
          customer_phone: '1234567890',
          txn_amount: 100
        }
      end

      it 'returns error 404' do
        headers = { 'Authorization' => "Bearer #{ @active_merchant.api_token.token}", 'Content-Type' => 'application/json' }

        post '/api/transactions/invalid_transaction_type', params: valid_authorize_params.to_json, headers: headers
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
