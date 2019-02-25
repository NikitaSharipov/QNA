class AddFacebookNameToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :facebook_name, :string
  end
end
