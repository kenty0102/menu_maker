class Design < ApplicationRecord
  validates :name, presence: true
  validates :layout, presence: true
end
