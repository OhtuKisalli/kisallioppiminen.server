class AddArchivedToTeachings < ActiveRecord::Migration[5.0]
  def change
    add_column :teachings, :archived, :boolean, default: false
    Teaching.all.each{ |t| t.archived = false; t.save }
  end
end
