class TransactionsController < ApplicationController
  # GET /transaction/transactions
  def index
    @transactions = Transaction.kept.includes(:merchant).order(:created_at)

    ActiveRecord::Associations::Preloader.new(
      records: Payment.where(transaction: @transactions),
      associations: nil
    ).call
  end
end
