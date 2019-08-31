class AddEmailToAccountants < ActiveRecord::Migration[5.2]
  def change
    add_column :accountants, :email, :string
  end
end
