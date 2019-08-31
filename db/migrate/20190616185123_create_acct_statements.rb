class CreateAcctStatements < ActiveRecord::Migration[5.2]
  def change
    create_table :acct_statements do |t|
      t.string :action
      t.string :message
      t.integer :acc_sender_id
      t.integer :acc_receiver_id
      t.string :balance
      t.integer :cust_sender_id
      t.integer :cust_receiver_id
      t.integer :acct_sender_id
      t.integer :acct_receiver_id
      t.timestamps
    end
  end
end
