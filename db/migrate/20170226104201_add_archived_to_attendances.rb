class AddArchivedToAttendances < ActiveRecord::Migration[5.0]
  def change
    add_column :attendances, :archived, :boolean, default: false
    Attendance.all.each{ |a| a.archived = false; a.save }
  end
end
