class RecipesController < ApplicationController
  require 'mechanize'
  before_action :require_login

  def search; end

  def save_options; end

  def auto_save
    @recipe = Recipe.new
  end

  def fetch_recipe
    service = scraper_for(fetch_recipe_params[:source_url]) # source_urlから対応するスクレイピングサービスオブジェクトを選択
    basic_info = service.fetch_basic_info # serviceオブジェクトのfetch_basic_infoメソッドを呼び出し
    ingredients_and_instructions = service.fetch_ingredients_and_instructions # serviceオブジェクトのfetch_ingredients_and_instructionメソッドを呼び出し

    image_url = basic_info[:image_url]

    if Recipe.exists?(source_url: basic_info[:source_url]) # 入力したURLがすでに存在する場合
      existing_recipe = current_user.recipes.find_by(source_url: basic_info[:source_url])
      if existing_recipe.update(title: basic_info[:title], scraped_at: basic_info[:scraped_at])
        update_ingredients_and_instructions(existing_recipe, ingredients_and_instructions)

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
      @recipe = current_user.recipes.new(title: basic_info[:title], source_url: basic_info[:source_url], source_site_name: basic_info[:source_site_name], scraped_at: basic_info[:scraped_at])
      set_ingredients_and_instructions(@recipe, ingredients_and_instructions)

      # 画像のダウンロードとアップロード
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
    @q = current_user.recipes.ransack(params[:q])
    @recipes = @q.result(distinct: true).includes(:ingredients).order(created_at: :desc)
  end

  def autocomplete_title
    @search_results = current_user.recipes.where("title like ?", "%#{params[:q]}%").pluck(:title)
    render layout: false
  end

  def autocomplete_ingredients
    user_recipe_ids = Recipe.where(user_id: current_user.id).pluck(:id)
    user_ingredients = Ingredient.where(recipe_id: user_recipe_ids)
    @search_results = user_ingredients.where("name LIKE ?", "%#{params[:q]}%").distinct(true).pluck(:name)
    render layout: false
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
      redirect_to recipe_path(@recipe), success: t('.success')
    else
      @recipe.ingredients.build if @recipe.ingredients.empty?
      @recipe.instructions.build if @recipe.instructions.empty?
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

  def destroy
    recipe = current_user.recipes.find(params[:id])
    recipe.destroy!
    redirect_to recipes_path, success: t('.success')
  end

  private

  def fetch_recipe_params
    params.require(:recipe).permit(:source_url)
  end

  def scraper_for(url)
    case URI.parse(url).host
    when /cookpad/
      RecipeScrapers::CookpadScraper.new(url)
    when /delishkitchen/
      RecipeScrapers::DelishKitchenScraper.new(url)
    when /kurashiru/
      RecipeScrapers::KurashiruScraper.new(url)
    else
      raise '対応していないサイトです'
    end
  end

  # fetch_recipeアクション(更新)
  def update_ingredients_and_instructions(recipe, ingredients_and_instructions)
    # 材料を更新
    ingredients_and_instructions[:ingredients].each do |ingredient_data|
      name = ingredient_data[:name]
      quantity = ingredient_data[:quantity]
      unit = ingredient_data[:unit]
      updated_at = Time.current

      existing_ingredient = recipe.ingredients.find_by(name:)
      if existing_ingredient
        existing_ingredient.update(quantity:, unit:, updated_at:)
      else
        recipe.ingredients.build(name:, quantity:, unit:, updated_at:)
      end
    end

    # 作り方を更新
    ingredients_and_instructions[:instructions].each do |instruction_data|
      step_number = instruction_data[:step_number]
      description = instruction_data[:description]
      updated_at = Time.current

      existing_instruction = recipe.instructions.find_by(step_number:)
      if existing_instruction
        existing_instruction.update(description:, updated_at:)
      else
        recipe.instructions.build(step_number:, description:, updated_at:)
      end
    end
  end

  # fetch_recipeアクション（新規保存）
  def set_ingredients_and_instructions(recipe, ingredients_and_instructions)
    # 材料を設定
    ingredients_and_instructions[:ingredients].each do |ingredient_data|
      name = ingredient_data[:name]
      quantity = ingredient_data[:quantity]
      unit = ingredient_data[:unit]
      recipe.ingredients.build(name:, quantity:, unit:)
    end

    # 作り方を設定
    ingredients_and_instructions[:instructions].each do |instruction_data|
      step_number = instruction_data[:step_number]
      description = instruction_data[:description]
      recipe.instructions.build(step_number:, description:)
    end
  end

  def recipe_params
    params.require(:recipe).permit(:title, :image, :image_cache, ingredients_attributes: [:id, :name, :quantity, :unit, :_destroy], instructions_attributes: [:id, :step_number, :description, :_destroy])
  end

  # updateアクション
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
end
