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
    source_site_name = Recipe.determine_source_site_name(source_url) # models/recipe.rbに定義したdetermine_source_site_nameメソッドでサイト名を取得
    scraped_at = Time.current

    if Recipe.exists?(source_url:) # 入力したURLがすでに存在する場合
      existing_recipe = current_user.recipes.find_by(source_url:)
      existing_recipe.update(title:, image_url:, scraped_at:)

      # 材料の情報を更新または作成
      page.search('.ingredient_row').each do |ingredient_row|
        name = ingredient_row.at('.ingredient_name .name').text
        quantity_text = ingredient_row.at('.ingredient_quantity.amount').text.strip
        quantity, unit = Recipe.parse_quantity_and_unit(quantity_text)

        # 既存の材料を探す
        existing_ingredient = existing_recipe.ingredients.find_by(name:) # 材料名が同じingredientsの情報を探す
        if existing_ingredient
          existing_ingredient.update(quantity:, unit:)
        else
          existing_recipe.ingredients.build(name:, quantity:, unit:)
        end
      end

      # 手順の情報を更新または作成
      page.search('.step').each_with_index do |step, index|
        description = step.text.strip

        # 既存の手順を探す
        existing_instruction = existing_recipe.instructions.find_by(step_number: index + 1)
        if existing_instruction
          existing_instruction.update(description:)
        else
          existing_recipe.instructions.build(step_number: index + 1, description:)
        end
      end

      if existing_recipe.save
        flash[:success] = t('.update_success')
      else
        flash[:danger] = t('.update_failure')
      end
    else
      # レシピを作成
      @recipe = current_user.recipes.new(title:, image_url:, source_url:, source_site_name:, scraped_at:)

      # 材料の情報を取得して@recipeに関連付け
      page.search('.ingredient_row').each do |ingredient_row| # '.ingredient_row'クラスを持つ要素を全て検索し、それぞれの要素について処理を行う
        name = ingredient_row.at('.ingredient_name .name').text
        quantity_text = ingredient_row.at('.ingredient_quantity.amount').text.strip
        quantity, unit = Recipe.parse_quantity_and_unit(quantity_text) # models/recipe.rbに定義したparse_quantity_and_unitメソッドで量と単位を取得

        @recipe.ingredients.build(name:, quantity:, unit:)
      end

      # 手順の情報を取得して追加
      page.search('.step').each_with_index do |step, index| # '.step'クラスを持つ要素をすべて検索し、それぞれの要素について処理を行う
        description = step.text.strip
        @recipe.instructions.build(step_number: index + 1, description:)
      end

      # 保存成功、失敗時のメッセージ表示
      if @recipe.save
        flash[:success] = t('.success')
      else
        flash[:danger] = t('.failure')
      end
    end

    redirect_to root_path
  end

  def new
    @recipe = Recipe.new
    @recipe.ingredients.build
    @recipe.instructions.build
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

  private

  def fetch_recipe_params
    params.require(:recipe).permit(:source_url)
  end

  def recipe_params
    params.require(:recipe).permit(:title, :image, :image_cache, ingredients_attributes: [:id, :name, :quantity, :unit, :_destroy], instructions_attributes: [:id, :step_number, :description, :_destroy])
  end
end
