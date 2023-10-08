class ValidateTransactionParams
  include Interactor

  def call
    transaction_params = context.transaction_params
    context.form = send("#{context.transaction_type}_form")    
    
    unless context.form.validate(transaction_params)
      context.fail!(message: context.form.errors.full_messages.join(', '))
    end

    unless context.transaction_type == :reversal_transaction
      context.amount = transaction_params[:txn_amount] || transaction_params[:payment][:amount]
    end

    context.reference_transaction_id = transaction_params[:reference_transaction_id]
    context.merchant_id = transaction_params[:merchant_id]
    
    context.customer_email = transaction_params[:customer_email]
    context.customer_phone = transaction_params[:customer_phone]
  end

  private

  def form_class_name(transaction_type)
    "#{transaction_type.to_s.camelize}Form"
  end

  [:authorize_transaction, :charge_transaction, :refund_transaction, :reversal_transaction].each do |payment_transaction_type|
    define_method("#{payment_transaction_type}_form") do
      form_class = Object.const_get form_class_name(payment_transaction_type)

      if payment_transaction_type == :authorize_transaction
        form_class.new(Object.const_get(payment_transaction_type.to_s.camelize).new, payment: Payment.new)
      else
        form_class.new(Object.const_get(payment_transaction_type.to_s.camelize).new)
      end
    end
  end
end
