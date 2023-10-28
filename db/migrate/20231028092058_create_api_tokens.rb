class CreateApiTokens < ActiveRecord::Migration[7.1]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :api_tokens do |t|
      t.integer :merchant_id, null: false, index: { unique: true }
      t.uuid :token, default: 'gen_random_uuid()', null: false, index: { unique: true }

      t.timestamps
    end
  end
end
