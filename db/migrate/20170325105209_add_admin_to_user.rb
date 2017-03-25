class AddAdminToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :admin, :boolean, default: false
    User.all.each{ |u| u.admin = false; u.save }
  end
end
