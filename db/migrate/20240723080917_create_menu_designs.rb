class CreateMenuDesigns < ActiveRecord::Migration[7.1]
  def change
    create_table :menu_designs do |t|
      t.references :menu, null: false, foreign_key: true
      t.references :design, null: false, foreign_key: true

      t.timestamps
    end
  end
end
