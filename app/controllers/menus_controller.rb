class MenusController < ApplicationController
  before_action :require_login

  def index
    @q = current_user.menus.ransack(params[:q])
    @menus = @q.result(distinct: true).includes(:recipes).order(created_at: :desc)
  end

  def autocomplete_title
    @search_results = current_user.menus.where("title like ?", "%#{params[:q]}%").pluck(:title)
    render layout: false
  end

  def autocomplete_recipes
    menu_ids = current_user.menus.pluck(:id)
    user_recipes = Recipe.joins(:menu_recipes).where(menu_recipes: { menu_id: menu_ids })
    @search_results = user_recipes.where("title LIKE ?", "%#{params[:q]}%").pluck(:title)
    render layout: false
  end

  def show
    @menu = Menu.find(params[:id])
    design = Design.find_by(name: '居酒屋風メニュー')
    @layout = JSON.parse(design.layout)
    @recipes = @menu.recipes
  end

  def new
    @menu = Menu.new
    @q = current_user.recipes.ransack(params[:q])
    @recipes = @q.result(distinct: true).includes(:ingredients).order(created_at: :desc)
  end

  def edit
    @menu = current_user.menus.find(params[:id])
    @recipes = current_user.recipes
    @selected_recipes = @menu.recipes.pluck(:id)
  end

  def create
    @menu = current_user.menus.new(menu_params)

    if @menu.save
      menu_params[:recipe_ids].uniq.each do |recipe_id|
        MenuRecipe.find_or_create_by(menu_id: @menu.id, recipe_id:)
      end

      default_design_id = 1
      MenuDesign.create(menu_id: @menu.id, design_id: default_design_id)

      redirect_to menu_path(@menu), success: t('.success')
    else
      @recipes = current_user.recipes
      flash.now[:danger] = t('.failure')
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @menu = current_user.menus.find(params[:id])

    # recipe_ids が nil の場合に空の配列として扱う
    recipe_ids = menu_params[:recipe_ids] || []

    if @menu.update(menu_params.merge(recipe_ids:))
      # 新しいレシピのIDを取得
      new_recipe_ids = menu_params[:recipe_ids].compact_blank.map(&:to_i)

      # 現在のレシピのIDを取得
      current_recipe_ids = @menu.recipes.pluck(:id)

      # 新しく追加するレシピIDと削除するレシピIDを計算
      recipes_to_add = new_recipe_ids - current_recipe_ids
      recipes_to_remove = current_recipe_ids - new_recipe_ids

      # 新しいレシピを追加
      recipes_to_add.each do |recipe_id|
        @menu.menu_recipes.create!(recipe_id:)
      end

      # 古いレシピを削除
      @menu.menu_recipes.where(recipe_id: recipes_to_remove).destroy_all

      redirect_to menu_path(@menu), success: t('.success')
    else
      @recipes = current_user.recipes
      @selected_recipes = @menu.recipes.pluck(:id)
      flash.now[:danger] = t('.failure')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    menu = current_user.menus.find(params[:id])
    menu.destroy!
    redirect_to menus_path, success: t('.success')
  end

  private

  def menu_params
    params.require(:menu).permit(:title, recipe_ids: [])
  end
end
