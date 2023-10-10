class TransactionsController < ApplicationController
  # GET /transaction/new/:transaction_type
  def new
    @transaction_type = params[:transaction_type].to_sym
    @merchants = Merchant.active.pluck(:id, :name)
    
    @form = transaction_form
  end

  # GET /transaction/transactions
  def index
    @transactions = Transaction.all.includes(:merchant, :payment)
  end

  def create
    redirect_to root_path
  end


  private

  def authorize_transaction_params
    params.require(:authorize_transaction).permit(
      :merchant_id,
      :customer_email,
      :customer_phone,
      payment: [:amount]
    )
  end

  def transaction_form
    transaction_class = Object.const_get "#{@transaction_type}_transaction".camelize
    transaction_form_class = Object.const_get "#{@transaction_type}_transaction_form".camelize

    transaction_form_class.new(transaction_class.new)
  end
end
