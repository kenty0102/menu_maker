class RenameImageColumnInRecipes < ActiveRecord::Migration[7.1]
  def change
    rename_column :recipes, :image_url, :image
  end
end
