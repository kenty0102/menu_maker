class MenusController < ApplicationController
  require 'aws-sdk-s3'
  before_action :require_login
  skip_before_action :require_login, only: :show

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

  def upload_image
    image_data = params[:image]
    bucket_name = ENV.fetch('AWS_S3_BUCKET')

    # S3にアップロード
    s3 = Aws::S3::Resource.new
    obj = s3.bucket(bucket_name).object("menus/#{SecureRandom.uuid}.png")
    obj.put(
      body: Base64.decode64(image_data.split(',')[1]),
      content_type: 'image/png', # MIMEタイプを明示的に設定
      content_disposition: 'inline' # プレビュー表示のためにinlineに設定
    )

    render json: { url: obj.public_url } # URLを返す
  end

  def save_image_url
    @menu = current_user.menus.find(params[:menu_id]) # メニューIDで特定のレコードを取得
    @menu.image_url = params[:image_url] # 画像URLを設定
    @menu.save
  end

  def reset_upload_flag
    session[:upload_image] = false
    head :ok
  end

  def index
    @q = current_user.menus.ransack(params[:q])
    @menus = @q.result(distinct: true).includes(:recipes).order(created_at: :desc)
  end

  def show
    @menu = Menu.find(params[:id])
    @layout = fetch_layout(@menu)
    @recipes = @menu.recipes
    @menu_recipes = @menu.menu_recipes.includes(:recipe)

    respond_to do |format|
      format.html # `show.html.erb` ビューを表示
      format.json { render json: { upload_image: session[:upload_image], menu: @menu, recipes: @recipes } }
    end
  end

  def new
    @menu = Menu.new
    @q = current_user.recipes.ransack(params[:q])
    @recipes = @q.result(distinct: true).includes(:ingredients).order(created_at: :desc)
    @designs = Design.all
  end

  def edit
    @menu = current_user.menus.find(params[:id])
    @recipes = current_user.recipes.order(created_at: :desc)
    @selected_recipes = @menu.recipes.pluck(:id)
    @designs = Design.all
    @selected_design = @menu.design_id
    @menu_recipe_notes = @menu.menu_recipes.each_with_object({}) do |menu_recipe, notes|
      notes[menu_recipe.recipe_id] = menu_recipe.note
    end
  end

  def create
    @menu = current_user.menus.new(menu_params.except(:recipe_notes))

    if @menu.save
      @menu.save_recipe_notes(menu_params[:recipe_ids], menu_params[:recipe_notes])
      session[:upload_image] = true # フラグを設定
      redirect_to menu_path(@menu), success: t('.success')
    else
      @q = current_user.recipes.ransack(params[:q])
      @recipes = @q.result(distinct: true).includes(:ingredients).order(created_at: :desc)
      @designs = Design.all
      flash.now[:danger] = t('.failure')
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @menu = current_user.menus.find(params[:id])
    recipe_ids = menu_params[:recipe_ids] || [] # recipe_ids が nil の場合に空の配列として扱う

    if @menu.update(menu_params.except(:recipe_notes).merge(recipe_ids:))
      new_recipe_ids = menu_params[:recipe_ids].compact_blank.map(&:to_i) # 新しいレシピのIDを取得
      current_recipe_ids = @menu.recipes.pluck(:id) # 現在のレシピのIDを取得

      @menu.update_recipes(new_recipe_ids, current_recipe_ids)
      @menu.update_recipe_notes(menu_params[:recipe_notes])

      session[:upload_image] = true # フラグを設定
      redirect_to menu_path(@menu), success: t('.success')
    else
      @recipes = current_user.recipes.order(created_at: :desc)
      @selected_recipes = @menu.recipes.pluck(:id)
      @designs = Design.all
      @selected_design = @menu.design_id
      @menu_recipe_notes = @menu.menu_recipes.each_with_object({}) do |menu_recipe, notes|
        notes[menu_recipe.recipe_id] = menu_recipe.note
      end
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
    params.require(:menu).permit(:title, :design_id, recipe_ids: [], recipe_notes: {})
  end

  def fetch_layout(menu)
    if menu.design_id.present?
      JSON.parse(menu.design.layout)
    else
      default_design = Design.find_by(id: 1)
      JSON.parse(default_design.layout)
    end
  end
end
