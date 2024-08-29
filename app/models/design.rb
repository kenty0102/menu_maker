class Design < ApplicationRecord
  has_many :menus, dependent: :destroy

  validates :name, presence: true
  validates :layout, presence: true
end
