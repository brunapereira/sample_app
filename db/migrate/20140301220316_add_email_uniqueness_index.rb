class AddEmailUniquenessIndex < ActiveRecord::Migration
  def change
    add_index :users, :email, unique: true
  end

  def destroy
    remove_index :users, :email
  end
end
