class AddTransactionTypeToTransactions < ActiveRecord::Migration[7.1]
  def change
    add_column :transactions, :transaction_type, :string, null: false, default: 'Transaction'
  end
end
