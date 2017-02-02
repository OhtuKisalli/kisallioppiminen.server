class CreateDeadlines < ActiveRecord::Migration[5.0]
  def change
    create_table :deadlines do |t|
      t.string :description
      t.datetime :deadline

      t.timestamps
    end
  end
end
