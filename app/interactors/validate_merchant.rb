class ValidateMerchant
  include Interactor

  def call
    merchant_id = context.merchant_id
    merchant = Merchant.find_by(id: merchant_id)

    #TODO: Validate with merchant id matches with merchant-id of reference_transaction_id or not
    context.fail!(message: 'Merchant is not present') if merchant.blank?
    context.fail!(message: 'Merchant is not active') unless merchant.active?

    context.merchant = merchant
  end
end