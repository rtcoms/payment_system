class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_enum :transaction_status, ['approved', 'reversed', 'refunded', 'error']

    create_table :transactions do |t|
      t.uuid :uuid, default: -> { 'gen_random_uuid()' }, null: false
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.enum :status, enum_type: 'transaction_status', default: 'approved', null: false
      t.string :customer_email, null: false
      t.string :customer_phone
      t.belongs_to :merchant, index: true, null: false
      t.references :reference_transaction, foreign_key: { to_table: :transactions }, index: true
      t.timestamps
    end

    add_index :transactions, :uuid, unique: true
    add_index :transactions, :status
  end
end
