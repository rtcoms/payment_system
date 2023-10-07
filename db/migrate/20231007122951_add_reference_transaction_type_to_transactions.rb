class AddReferenceTransactionTypeToTransactions < ActiveRecord::Migration[7.1]
  def change
    add_column :transactions, :reference_transaction_type, :string

    remove_index :transactions, :reference_transaction_id
    add_index :transactions, [:reference_transaction_type, :reference_transaction_id]
  end
end
