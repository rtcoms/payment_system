# Validator to validate params for transaction creation. it uses respective TransactionForm classes to validate 
# transaction params
class ValidateTransactionParams
  include Interactor

  def call
    transaction_params = context.transaction_params
    context.form = send("#{context.transaction_type}_form")    
    

    # Validate transaction params using form object
    unless context.form.validate(transaction_params)
      # Update validation errors and fail process
      context.fail!(message: context.form.errors.full_messages.join(', '))
    end

    unless context.transaction_type == :reversal_transaction
      # Set transaction amount for non reversal transactions
      context.amount = transaction_params[:txn_amount]
    end

    context.reference_transaction_id = transaction_params[:reference_transaction_id]
    context.merchant_id = transaction_params[:merchant_id]
    context.customer_email = transaction_params[:customer_email]
    context.customer_phone = transaction_params[:customer_phone]
  end

  private

  # @returns [String] Form class name for a given transaction type : [:authorize, :charge, "refund, :reversal"]
  def form_class_name(transaction_type)
    "#{transaction_type.to_s.camelize}Form"
  end

  # 
  Transaction::Type::ALL.each do |txn_type|
    transaction_type = "#{txn_type}_transaction"
    define_method("#{transaction_type}_form") do
      form_class = Object.const_get form_class_name(transaction_type)

      if transaction_type == :authorize_transaction
        form_class.new(Object.const_get(transaction_type.to_s.camelize).new, payment: Payment.new)
      else
        form_class.new(Object.const_get(transaction_type.to_s.camelize).new)
      end
    end
  end
end
