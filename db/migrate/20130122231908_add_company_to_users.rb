class AddCompanyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :company, :integer
    add_index :users, :company
  end
end
