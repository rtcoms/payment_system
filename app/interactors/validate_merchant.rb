class ValidateMerchant
  include Interactor

  def call
    merchant_id = context.merchant_id
    merchant = Merchant.find_by(id: merchant_id)

    reference_transaction = Transaction.find(context.reference_transaction_id) if context.reference_transaction_id.present?

    context.fail!(message: 'Merchant is not present') if merchant.blank?
    context.fail!(message: 'Merchant is not active') unless merchant.active?
    context.fail!(message: 'Merchant and reference transaction mismatch') if reference_transaction.present? && reference_transaction.merchant_id != merchant_id

    context.merchant = merchant
    context.reference_transaction = reference_transaction
  end
end