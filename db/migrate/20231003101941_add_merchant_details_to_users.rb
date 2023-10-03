class AddMerchantDetailsToUsers < ActiveRecord::Migration[7.0]
  def up
    create_enum :user_status, ['active', 'inactive']

    change_table :users do |t|
      t.enum :status, enum_type: 'user_status', default: 'active', null: false
    end

    add_column :users, :name, :string, null: false
    add_column :users, :description, :text
    add_column :users, :total_transaction_sum, :decimal, default: 0, null: false
  end

  def down
    remove_column :users, :status
    remove_column :users, :name
    remove_column :users, :description
    remove_column :users, :total_transaction_sum

    drop_enum :user_status
  end
end
