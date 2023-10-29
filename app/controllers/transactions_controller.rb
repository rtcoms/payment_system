class TransactionsController < ApplicationController
  # GET /transaction/transactions
  def index
    @transactions = Transaction.kept.includes(:merchant, :payment).order(:created_at)
  end
end
