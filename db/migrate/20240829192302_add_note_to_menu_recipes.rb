class AddNoteToMenuRecipes < ActiveRecord::Migration[7.1]
  def change
    add_column :menu_recipes, :note, :string
  end
end
