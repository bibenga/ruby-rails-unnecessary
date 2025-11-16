class AddNiknameToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :nikname, :string
    add_index :users, :nikname, unique: true
  end
end
