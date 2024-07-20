class RecipesController < ApplicationController
  require 'mechanize'
  before_action :require_login

  def search; end

  def save_options; end

  def auto_save
    @recipe = Recipe.new
  end

  def fetch_recipe
    # Mechanizeクラスをインスタンス化
    agent = Mechanize.new
    # 入力されたURLからWebページを取得
    page = agent.get(fetch_recipe_params[:source_url])

    # レシピの情報を取得
    title = page.search('.recipe-title').text.strip
    image_url = page.at('#main-photo img')['src']
    source_url = fetch_recipe_params[:source_url]
    source_site_name = Recipe.determine_source_site_name(source_url)
    scraped_at = Time.current

    if Recipe.exists?(source_url:) # 入力したURLがすでに存在する場合
      existing_recipe = current_user.recipes.find_by(source_url:)
      if existing_recipe.update(title:, scraped_at:)
        update_ingredients_and_instructions(existing_recipe, page)

        # 画像のダウンロードとアップロード
        if image_url.present?
          existing_recipe.remote_image_url = image_url
          existing_recipe.save
        end

        redirect_to recipes_path, success: t('.update_success')
      else
        flash.now[:danger] = t('.update_failure')
        render :auto_save, status: :unprocessable_entity
      end
    else
      # レシピを作成
      @recipe = current_user.recipes.new(title:, source_url:, source_site_name:, scraped_at:)
      set_ingredients_and_instructions(@recipe, page)

      # 画像のダウンロードとアップロードは保存後に行う
      if @recipe.save
        if image_url.present?
          @recipe.remote_image_url = image_url
          @recipe.save
        end
        redirect_to recipes_path, success: t('.success')
      else
        flash.now[:danger] = t('.failure')
        render :auto_save, status: :unprocessable_entity
      end
    end
  end

  def index
    @recipes = current_user.recipes.includes(:ingredients)
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def new
    @recipe = Recipe.new
    @recipe.ingredients.build
    @recipe.instructions.build
  end

  def edit
    @recipe = current_user.recipes.find(params[:id])
  end

  def create
    @recipe = current_user.recipes.new(recipe_params)
    if @recipe.save
      redirect_to root_path, success: t('.success')
    else
      flash.now[:danger] = t('.failure')
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @recipe = current_user.recipes.find(params[:id])
    updated_params = process_instructions(recipe_params)
    if @recipe.update(updated_params)
      redirect_to recipe_path(@recipe), success: t('.update_success')
    else
      flash.now[:danger] = t('.update_failure')
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def fetch_recipe_params
    params.require(:recipe).permit(:source_url)
  end

  def download_and_store_image(url, recipe)
    uploader = ImageUploader.new(recipe, :image)
    uploader.download!(url)
    uploader.store!
    uploader.url
  end

  def recipe_params
    params.require(:recipe).permit(:title, :image, :image_cache, ingredients_attributes: [:id, :name, :quantity, :unit, :_destroy], instructions_attributes: [:id, :step_number, :description, :_destroy])
  end

  def process_instructions(params)
    if params[:instructions_attributes].present?
      current_step = 1
      params[:instructions_attributes].each_value do |value|
        if value[:_destroy] != '1'
          value[:step_number] = current_step
          current_step += 1
        end
      end
    end
    params
  end

  def update_ingredients_and_instructions(recipe, page)
    page.search('.ingredient_row').each do |ingredient_row|
      name = ingredient_row.at('.ingredient_name .name').text
      quantity_text = ingredient_row.at('.ingredient_quantity.amount').text.strip
      quantity, unit = Recipe.parse_quantity_and_unit(quantity_text)
      updated_at = Time.current

      existing_ingredient = recipe.ingredients.find_by(name:)
      if existing_ingredient
        existing_ingredient.update(quantity:, unit:, updated_at:)
      else
        recipe.ingredients.build(name:, quantity:, unit:, updated_at:)
      end
    end

    page.search('.step_text').each_with_index do |step_text, index|
      description = step_text.text.strip
      updated_at = Time.current

      existing_instruction = recipe.instructions.find_by(step_number: index + 1)
      if existing_instruction
        existing_instruction.update(description:, updated_at:)
      else
        recipe.instructions.build(step_number: index + 1, description:, updated_at:)
      end
    end
  end

  def set_ingredients_and_instructions(recipe, page)
    page.search('.ingredient_row').each do |ingredient_row|
      name = ingredient_row.at('.ingredient_name .name').text
      quantity_text = ingredient_row.at('.ingredient_quantity.amount').text.strip
      quantity, unit = Recipe.parse_quantity_and_unit(quantity_text)
      recipe.ingredients.build(name:, quantity:, unit:)
    end

    page.search('.step_text').each_with_index do |step_text, index|
      description = step_text.text.strip
      recipe.instructions.build(step_number: index + 1, description:)
    end
  end
end
