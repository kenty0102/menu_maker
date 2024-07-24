class Menu < ApplicationRecord
  belongs_to :user
  has_many :menu_recipes, dependent: :destroy
  has_many :recipes, through: :menu_recipes
  has_many :menu_designs, dependent: :destroy
  has_many :designs, through: :menu_designs

  validates :title, presence: true, uniqueness: true
end
