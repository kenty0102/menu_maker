class Menu < ApplicationRecord
  belongs_to :user
  belongs_to :design, optional: true
  has_many :menu_recipes, dependent: :destroy
  has_many :recipes, through: :menu_recipes

  validates :title, presence: true
  validates :title, uniqueness: { scope: :user_id }
  validate :must_have_at_least_one_recipe
  validates :design_id, presence: true

  def save_recipe_notes(recipe_ids, recipe_notes)
    recipe_ids.uniq.each do |recipe_id|
      note = recipe_notes[recipe_id.to_s]
      menu_recipe = MenuRecipe.find_or_create_by(menu_id: id, recipe_id:)
      menu_recipe.update(note:) if note.present?
    end
  end

  def update_recipes(new_recipe_ids, current_recipe_ids)
    # 新しく追加するレシピIDと削除するレシピIDを計算
    recipes_to_add = new_recipe_ids - current_recipe_ids
    recipes_to_remove = current_recipe_ids - new_recipe_ids

    # 新しいレシピを追加
    recipes_to_add.each do |recipe_id|
      menu_recipes.create!(recipe_id:)
    end

    # 古いレシピを削除
    menu_recipes.where(recipe_id: recipes_to_remove).destroy_all
  end

  def update_recipe_notes(recipe_notes)
    recipe_ids.each do |recipe_id|
      note = recipe_notes[recipe_id.to_s]
      menu_recipe = menu_recipes.find_by(recipe_id:)
      menu_recipe.update(note:) if menu_recipe && note.present?
    end
  end

  # racsackで検索可能な属性を指定
  def self.ransackable_attributes(_auth_object = nil)
    ["title"]
  end

  # 関連モデルも検索対象に指定
  def self.ransackable_associations(_auth_object = nil)
    ["recipes"]
  end

  private

  def must_have_at_least_one_recipe
    errors.add(:base, :blank_recipe) if recipe_ids.blank?
  end
end
