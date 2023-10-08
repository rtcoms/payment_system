class ValidateMerchant
  include Interactor

  def call
    merchant_id = context.merchant_id
    merchant = Merchant.find_by(id: merchant_id)

    context.fail!(message: 'Merchant is not present') if merchant.blank?
    context.fail!(message: 'Merchant is not active') unless merchant.active?

    context.merchant = merchant
  end
end