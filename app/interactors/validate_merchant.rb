class ValidateMerchant
  include Interactor

  def call
    merchant_id = context.merchant_id
    merchant = Merchant.find_by(id: merchant_id)

    reference_transaction = Transaction.find(context.reference_transaction_id) if context.reference_transaction_id.present?

    #TODO: Validate with merchant id matches with merchant-id of reference_transaction_id or not
    context.fail!(message: 'Merchant is not present') if merchant.blank?
    context.fail!(message: 'Merchant is not active') unless merchant.active?
    context.fail!(message: 'Merchant and reference transaction mismatch') if reference_transaction.present? && reference_transaction.merchant_id != merchant_id

    context.merchant = merchant
    context.reference_transaction = reference_transaction
  end
end