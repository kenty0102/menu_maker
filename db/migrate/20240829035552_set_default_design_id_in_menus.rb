class SetDefaultDesignIdInMenus < ActiveRecord::Migration[7.1]
  def change
    default_design_id = 1
    Menu.find_each do |menu|
      menu.update_column(:design_id, default_design_id)
    end
  end
end