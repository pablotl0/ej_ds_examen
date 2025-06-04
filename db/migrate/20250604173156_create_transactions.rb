class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions, id: false do |t|
      t.string :id, null: false, primary_key: true
      t.string :transaction_type, null: false
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :origin_account, null: false
      t.string :destiny_account

      t.timestamps
    end
    
    add_index :transactions, :origin_account
    add_index :transactions, :destiny_account
  end
end
