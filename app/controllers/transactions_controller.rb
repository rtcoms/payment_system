class TransactionsController < ApplicationController
  include TransactionProcessor

  # GET /transaction/new/:transaction_type
  def new
    @transaction_type = "#{params[:transaction_type]}_transaction".to_sym
    @merchants = Merchant.active.pluck(:id, :name)

    @form = transaction_form
  end

  # GET /transaction/transactions
  def index
    @transactions = Transaction.kept.includes(:merchant, :payment).order(:created_at)
  end

  def create
    @transaction_type = params[:transaction_type].to_sym
    @transaction_params = params[@transaction_type]

    service_class = "Create#{params[:transaction_type].to_s.camelize}Service".constantize
    result = service_class.call(transaction_params: @transaction_params, transaction_type: @transaction_type)
    redirect_to transactions_path and return if result.success?
    @form = result.form
    @merchants = Merchant.active.pluck(:id, :name)
    render :new
  end

  private

  def transaction_form
    transaction_class = Object.const_get @transaction_type.to_s.camelize
    transaction_form_class = Object.const_get "#{@transaction_type}_form".camelize

    transaction_form_class.new(transaction_class.new)
  end
end
