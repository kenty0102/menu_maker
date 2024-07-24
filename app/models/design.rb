class Design < ApplicationRecord
  has_many :menu_designs, dependent: :destroy
  has_many :menus, through: :menu_designs

  validates :name, presence: true
  validates :layout, presence: true
end
