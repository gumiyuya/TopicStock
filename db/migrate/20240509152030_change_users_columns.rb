class ChangeUsersColumns < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :password_digest, :string
    remove_column :users, :password, :string
  end
end