class AddUniqueIndexToRecipes < ActiveRecord::Migration[7.1]
  def change
    add_index :recipes, :title, unique: true
  end
end
