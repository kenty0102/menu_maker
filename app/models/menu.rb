class Menu < ApplicationRecord
  belongs_to :user
  has_many :menu_recipes, dependent: :destroy
  has_many :recipes, through: :menu_recipes
  has_many :menu_designs, dependent: :destroy
  has_many :designs, through: :menu_designs

  validates :title, presence: true
  validates :title, uniqueness: { scope: :user_id }
  validate :must_have_at_least_one_recipe

  private

  def must_have_at_least_one_recipe
    errors.add(:base, :blank_recipe) if recipe_ids.blank?
  end
end
