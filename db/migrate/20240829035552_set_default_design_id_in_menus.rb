class SetDefaultDesignIdInMenus < ActiveRecord::Migration[7.1]
  def change
    Menu.find_each do |menu|
      design_id = menu.menu_designs.first&.design_id
      menu.update_column(:design_id, design_id) if design_id.present?
    end
  end
end
