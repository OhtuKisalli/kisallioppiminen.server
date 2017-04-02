class CreateExerciselists < ActiveRecord::Migration[5.0]
  def change
    create_table :exerciselists do |t|
      t.string :html_id, :null => false
    end
  end
end
