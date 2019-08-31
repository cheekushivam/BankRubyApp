class AddAccountTable < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :acc_type
      t.string :acc_balance
      t.integer :customer_id
      t.references :customer, foreign_key: true
      t.timestamps
    end
  end
end
