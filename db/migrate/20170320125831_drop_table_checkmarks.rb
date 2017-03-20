class DropTableCheckmarks < ActiveRecord::Migration[5.0]
  def change
    drop_table :checkmarks
  end
end
