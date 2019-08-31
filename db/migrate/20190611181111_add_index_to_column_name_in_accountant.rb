class AddIndexToColumnNameInAccountant < ActiveRecord::Migration[5.2]
  def change
    create_table :accountants do |t|
      t.string :acct_ssnid, :unique => true
      t.string :acct_name
      t.integer :acct_age
      t.string :acct_addr
      t.string :acct_state
      t.string :acct_city
      t.string :acct_designation
      t.timestamps
    end
  end
end
