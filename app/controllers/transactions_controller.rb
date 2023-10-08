class TransactionsController < ApplicationController
  # GET /transaction/new/:transaction_type
  def new
    @transaction_type = params[:transaction_type]
    @merchants = Merchant.active.pluck(:id, :name)
    
    @form = AuthorizeTransaction.new(payment: Payment.new)
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
end
