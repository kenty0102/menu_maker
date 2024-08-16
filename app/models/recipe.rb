class Recipe < ApplicationRecord
  mount_uploader :image, ImageUploader

  belongs_to :user
  has_many :ingredients, dependent: :destroy
  has_many :instructions, dependent: :destroy
  has_many :menu_recipes, dependent: :destroy
  has_many :menus, through: :menu_recipes

  accepts_nested_attributes_for :ingredients, allow_destroy: true
  accepts_nested_attributes_for :instructions, allow_destroy: true

  validates :title, presence: true
  validates :title, uniqueness: { scope: :user_id }
  validates :source_url, format: { with: URI::DEFAULT_PARSER.make_regexp }, allow_nil: true

  def self.parse_quantity_and_unit(quantity_text)
    match_data = quantity_text.match(/(\d+)\s*(.+)/) # 数量と単位を分離
    if match_data # 数量と単位が分離できた場合
      quantity = match_data[1].to_i # 数量を数値に変換
      unit = match_data[2].strip # 単位を取得（余分な空白を削除）
    else
      quantity = nil
      unit = quantity_text.strip # 数量がない場合（適量など）はquantity_text全体をunitに設定
    end
    [quantity, unit]
  end
end
