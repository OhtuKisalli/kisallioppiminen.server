class CreateCheckmarks < ActiveRecord::Migration[5.0]
  def change
    create_table :checkmarks do |t|
      t.integer :user_id
      t.integer :exercise_id
      t.string :status

      t.timestamps
    end
  end
end
