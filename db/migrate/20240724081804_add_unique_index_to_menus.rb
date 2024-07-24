class AddUniqueIndexToMenus < ActiveRecord::Migration[7.1]
  def change
    add_index :menus, :title, unique: true
  end
end
