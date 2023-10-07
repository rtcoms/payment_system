class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.decimal :amount
      t.references :monetizable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
