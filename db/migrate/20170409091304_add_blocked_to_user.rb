class AddBlockedToUser < ActiveRecord::Migration[5.0]
  def up
    add_column :users, :blocked, :boolean, default: false
    User.all.each{ |u| u.blocked = false; u.save }
  end
  def down
    remove_column :users, :blocked
  end
  
end
