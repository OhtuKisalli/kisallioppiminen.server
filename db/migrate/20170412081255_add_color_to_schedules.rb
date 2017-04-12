class AddColorToSchedules < ActiveRecord::Migration[5.0]
  def up
    add_column :schedules, :color, :integer
    Schedule.all.each{ |s| s.color = 1; s.save }
  end
  def down
    remove_column :schedules, :color
  end
end
