class AddNotNullConstraints < ActiveRecord::Migration[7.1]
  def change
    change_column_null :ingredients, :name, false
    change_column_null :ingredients, :unit, false

    change_column_null :instructions, :step_number, false
    change_column_null :instructions, :description, false

    change_column_null :menus, :title, false

    change_column_null :recipes, :title, false
  end
end
