class AddImageUrlToMenus < ActiveRecord::Migration[7.1]
  def change
    add_column :menus, :image_url, :string
  end
end
