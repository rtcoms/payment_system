RSpec.describe ValidateMerchant do
  describe '.call' do
    context 'when a valid merchant is present and active' do
      let(:valid_merchant) { create(:merchant, status: :active) }
      let(:valid_params) { { merchant_id: valid_merchant.id } }

      it 'succeeds and sets the merchant in context' do
        result = described_class.call(valid_params)

        expect(result).to be_success
        expect(result.merchant).to eq(valid_merchant)
      end
    end

    context 'when merchant is not present' do
      let(:invalid_params) { { authorize_transaction_params: { merchant_id: nil } } }

      it 'fails with an error message' do
        result = described_class.call(invalid_params)

        expect(result).to be_failure
        expect(result.message).to eq('Merchant is not present')
      end
    end

    context 'when merchant is not active' do
      let(:inactive_merchant) { create(:merchant, status: :inactive) }
      let(:inactive_params) { { merchant_id: inactive_merchant.id } }

      it 'fails with an error message' do
        result = described_class.call(inactive_params)

        expect(result).to be_failure
        expect(result.message).to eq('Merchant is not active')
      end
    end
  end
end