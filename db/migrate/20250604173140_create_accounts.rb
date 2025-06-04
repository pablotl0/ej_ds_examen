class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts, id: false do |t|
      t.string :id, null: false, primary_key: true
      t.references :user, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2, null: false, default: 0

      t.timestamps
    end
  end
end
