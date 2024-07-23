class CreateDesigns < ActiveRecord::Migration[7.1]
  def change
    create_table :designs do |t|
      t.string :name
      t.json :layout

      t.timestamps
    end
  end
end
