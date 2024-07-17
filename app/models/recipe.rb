class Recipe < ApplicationRecord
  mount_uploader :image, ImageUploader

  belongs_to :user
  has_many :ingredients, dependent: :destroy
  has_many :instructions, dependent: :destroy

  accepts_nested_attributes_for :ingredients, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :instructions, reject_if: :all_blank, allow_destroy: true

  validates :title, presence: true
  validates :source_url, format: { with: URI::DEFAULT_PARSER.make_regexp }, allow_nil: true

  def self.determine_source_site_name(url)
    require 'uri'
    uri = URI.parse(url) # URLを解析して、その結果をuriに入れる
    host = uri.host # 解析したURLのホスト名（ドメイン）を取得

    case host # 取得したホスト名についての条件分岐
    when 'cookpad.com'
      'Cookpad' # ホスト名が'cookpad.com'のときに'Cookpad'を返す
    else
      host # 条件に当てはまらない場合は、ホスト名をそのまま返す
    end
  end

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
