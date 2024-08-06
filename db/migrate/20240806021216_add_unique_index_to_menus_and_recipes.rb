class AddUniqueIndexToMenusAndRecipes < ActiveRecord::Migration[7.1]
  def change
    remove_index :menus, :title
    remove_index :recipes, :title

    add_index :menus, [:user_id, :title], unique: true
    add_index :recipes, [:user_id, :title], unique: true
  end
end
