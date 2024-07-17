class Ingredient < ApplicationRecord
  belongs_to :recipe

  validates :name, presence: true
  validates :unit, presence: true
  validates :quantity, allow_blank: true, numericality: true

  before_validation :convert_full_width_to_half_width

  private

  def convert_full_width_to_half_width
    self.quantity = quantity.tr('０-９．', '0-9.') if quantity.present?
  end
end
