class RemovePasswordDigestAndAddEncryptedPassword < ActiveRecord::Migration[8.1]
  def change
    remove_column :users, :password_digest, :string, if_exists: true
    remove_column :users, :email_address, :string, if_exists: true
  end
end
