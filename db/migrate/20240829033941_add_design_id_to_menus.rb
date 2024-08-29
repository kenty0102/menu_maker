class AddDesignIdToMenus < ActiveRecord::Migration[7.1]
  def change
    add_reference :menus, :design, foreign_key: true, null: true
  end
end
