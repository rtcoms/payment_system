class RemoveAmountFromTransactions < ActiveRecord::Migration[7.1]
  def change
    remove_column :transactions, :amount, :decimal
  end
end
