class DropMenuDesignsTable < ActiveRecord::Migration[7.1]
  def up
    drop_table :menu_designs, if_exists: true
  end

  def down
    create_table :menu_designs do |t|
      t.references :menu, null: false, foreign_key: true
      t.references :design, null: false, foreign_key: true

      t.timestamps
    end
  end
end
