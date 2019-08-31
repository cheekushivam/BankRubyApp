class AddIndexToColumnNameInCustomer < ActiveRecord::Migration[5.2]
  def change
    create_table :customers do |t|
      t.string :cust_ssnid, :unique => true
      t.references :accountant, foreign_key: true
      t.integer :accountant_id
      t.string :cust_name
      t.integer :cust_age
      t.string :cust_addr
      t.string :cust_state
      t.string :cust_city
      t.timestamps
    end
  end
end
