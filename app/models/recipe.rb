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

  # スクレイピングした材料の情報から数量と単位に分けて取り出す
  def self.parse_quantity_and_unit(quantity_text)
    match_data = quantity_text.match(/(\d+)\s*(.+)/) # 数量と単位を分離
    if match_data
      quantity = match_data[1].to_i # 数量を数値に変換
      unit = match_data[2].strip # 単位を取得（余分な空白を削除）
    else
      quantity = nil
      unit = quantity_text.strip # 数量がない場合（適量など）はquantity_text全体をunitに設定
    end
    [quantity, unit]
  end

  # 既存のレシピをアップデート
  def self.update_existing_recipe(user, basic_info, ingredients_and_instructions)
    existing_recipe = user.recipes.find_by(source_url: basic_info[:source_url])
    if existing_recipe.update(title: basic_info[:title], scraped_at: basic_info[:scraped_at])
      existing_recipe.update_ingredients_and_instructions(ingredients_and_instructions)
      existing_recipe.handle_image_upload(basic_info[:image_url])
      return true
    else
      return false
    end
  end

  # 材料、作り方をセット（update_existing_recipe）
  def update_ingredients_and_instructions(ingredients_and_instructions)
    ingredients_and_instructions[:ingredients].each do |ingredient_data|
      name = ingredient_data[:name]
      quantity = ingredient_data[:quantity]
      unit = ingredient_data[:unit]

      # 材料名が空の場合はデフォルトの値を設定
      name = '-----' if name.blank?
      # 単位が空の場合はデフォルトの値を設定
      unit = '--' if unit.blank?

      updated_at = Time.current

      existing_ingredient = self.ingredients.find_by(name:)
      if existing_ingredient
        existing_ingredient.update(quantity:, unit:, updated_at:)
      else
        recipe.ingredients.build(name:, quantity:, unit:, updated_at:)
      end
    end

    ingredients_and_instructions[:instructions].each do |instruction_data|
      step_number = instruction_data[:step_number]
      description = instruction_data[:description]

      # 作り方が空の場合はデフォルトの値を設定
      description = '-----' if description.blank?

      updated_at = Time.current

      existing_instruction = self.instructions.find_by(step_number:)
      if existing_instruction
        existing_instruction.update(description:, updated_at:)
      else
        recipe.instructions.build(step_number:, description:, updated_at:)
      end
    end

    save if changed?
  end

  # レシピを新たに保存
  def self.create_new_recipe(user, basic_info, ingredients_and_instructions)
    recipe = user.recipes.new(
      title: basic_info[:title],
      source_url: basic_info[:source_url],
      source_site_name: basic_info[:source_site_name],
      scraped_at: basic_info[:scraped_at]
    )
    recipe.set_ingredients_and_instructions(ingredients_and_instructions)
    recipe.handle_image_upload(basic_info[:image_url])

    if recipe.save
      return true
    else
      Rails.logger.error recipe.errors.full_messages.join(", ")
      return false
    end
  end

  # 材料、作り方をセット（create_new_recipe）
  def set_ingredients_and_instructions(ingredients_and_instructions)
    ingredients_and_instructions[:ingredients].each do |ingredient_data|
      name = ingredient_data[:name]
      quantity = ingredient_data[:quantity]
      unit = ingredient_data[:unit]

      # 材料名が空の場合はデフォルトの値を設定
      name = '-----' if name.blank?
      # 単位が空の場合はデフォルトの値を設定
      unit = '--' if unit.blank?

      self.ingredients.build(name:, quantity:, unit:)
    end

    ingredients_and_instructions[:instructions].each do |instruction_data|
      step_number = instruction_data[:step_number]
      description = instruction_data[:description]

      # 作り方が空の場合はデフォルトの値を設定
      description = '-----' if description.blank?

      self.instructions.build(step_number:, description:)
    end
  end

  # 画像の保存とアップロード
  def handle_image_upload(image_url)
    return if image_url.blank?
  
    self.remote_image_url = image_url # 画像のアップロード
    self.save
  end

  # racsackで検索可能な属性を指定
  def self.ransackable_attributes(_auth_object = nil)
    ["title"]
  end

  # 関連モデルも検索対象に指定
  def self.ransackable_associations(_auth_object = nil)
    ["ingredients"]
  end
end
