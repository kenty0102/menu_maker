class CreateInstructions < ActiveRecord::Migration[7.1]
  def change
    create_table :instructions do |t|
      t.references :recipe, null: false, foreign_key: true
      t.integer :step_number
      t.text :description

      t.timestamps
    end
  end
end
