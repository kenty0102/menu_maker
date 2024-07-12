class Ingredient < ApplicationRecord
  belongs_to :recipe

  validates :name, presence: true
  validates :unit, presence: true
  validates :quantity, numericality: true, allow_nil: true
end
