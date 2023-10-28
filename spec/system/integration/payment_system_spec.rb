require 'rails_helper'

RSpec.describe 'Payment system' do
  let(:api_token) { Rails.application.config.api_settings['api_token'] }
  let!(:admin) { create(:admin, email: 'admin@example.com', password: 'password', password_confirmation: 'password') }
  let!(:active_merchant) do
    create(:merchant, email: 'merchant1@example.com', password: 'password', password_confirmation: 'password',
                      status: 'active')
  end
  let!(:inactive_merchant) do
    create(:merchant, email: 'merchant2@example.com', password: 'password', password_confirmation: 'password',
                      status: 'inactive')
  end

  let!(:authorize1_txn_params) do
    {
      merchant_id: active_merchant.id,
      customer_email: 'test@example.com',
      customer_phone: '1234567890',
      txn_amount: 300
    }
  end

  let!(:authorize2_txn_params) do
    {
      merchant_id: active_merchant.id,
      customer_email: 'test@example.com',
      customer_phone: '1234567890',
      txn_amount: 100
    }
  end

  describe 'Display home page' do
    before do
      @headers = {
        'Authorization' => "Bearer #{active_merchant.api_token.token}",
        'Content-Type' => 'application/json'
      }

      # create authorization transaction using api /transactions/authorize
      post '/api/transactions/authorize', params: authorize1_txn_params.to_json, headers: @headers
      post '/api/transactions/authorize', params: authorize2_txn_params.to_json, headers: @headers

      @authorize_txn_1 = AuthorizeTransaction.first
      @authorize_txn_2 = AuthorizeTransaction.last

      3.times do
        post('/api/transactions/charge', params: { reference_transaction_id: @authorize_txn_1.id, merchant_id: active_merchant.id, customer_email: 'customer@example.com', txn_amount: 100 }.to_json, headers: @headers)
      end

      visit merchant_path(active_merchant)
      
      # Make it a reuseable sign_in method
      fill_in('Email', with: admin.email); fill_in('Password', with: 'password'); click_button('commit')


      expect(page).to have_content("Total transaction sum: 300.0")
      

      post('/api/transactions/refund', params: { reference_transaction_id: ChargeTransaction.last.id, merchant_id: active_merchant.id, customer_email: 'customer@example.com', txn_amount: 100 }.to_json, headers: @headers)
      visit merchant_path(active_merchant)
      expect(page).to have_content("Total transaction sum: 200.0")

      post('/api/transactions/charge', params: { reference_transaction_id: @authorize_txn_2.id, merchant_id: active_merchant.id, customer_email: 'customer@example.com', txn_amount: 100 }.to_json, headers: @headers)
      visit merchant_path(active_merchant)
      expect(page).to have_content("Total transaction sum: 300.0")

      post('/api/transactions/charge', params: { reference_transaction_id: @authorize_txn_2.id, merchant_id: active_merchant.id, customer_email: 'customer@example.com', txn_amount: 100 }.to_json, headers: @headers)
      visit merchant_path(active_merchant)
      expect(page).to have_content("Total transaction sum: 300.0")

      post('/api/transactions/reversal', params: { reference_transaction_id: @authorize_txn_1.id, merchant_id: active_merchant.id, customer_email: 'customer@example.com' }.to_json, headers: @headers)
      visit merchant_path(active_merchant)
      expect(page).to have_content("Total transaction sum: 100.0")

      
      
      visit transactions_path
    


    end

    it 'should have payment system brand name' do
      visit '/'

      expect(find('.navbar-brand')).to have_text('Payment System')
    end
  end
end
