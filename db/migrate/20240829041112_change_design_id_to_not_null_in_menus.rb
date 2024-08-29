class ChangeDesignIdToNotNullInMenus < ActiveRecord::Migration[7.1]
  def change
    change_column_null :menus, :design_id, false
  end
end
