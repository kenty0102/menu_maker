class RecipesController < ApplicationController
  require 'mechanize'
  require 'cgi'
  skip_before_action :require_login, only: :show

  def search
    @query = params[:query]
    @recipes = []

    if @query.present?
      # Cookpadからレシピを取得
      @recipes += scrape_cookpad(@query)
      # DELISH KITCHENからレシピを取得
      @recipes += scrape_delish_kitchen(@query)
      # クラシルからレシピを取得
      @recipes += scrape_kurashiru(@query)
    end

    @recipes.sort_by! { |recipe| recipe[:title].to_s }
    
    render :search
  end

  def search_show
    @source_site_url = params[:source_url]
    agent = Mechanize.new
    page = agent.get(@source_site_url)
    source_site = RecipeScrapers::RecipeScraper.new(@source_site_url)
    @source_site_name = source_site.determine_source_site_name(@source_site_url)

    case URI.parse(@source_site_url).host
    when /cookpad/
      @title = page.at('h1.break-words').text.strip  # レシピタイトル
      @image_url = page.at('picture img')['src']  # レシピ画像URL
      @ingredients = page.search('#ingredients .ingredient-list ol li').map do |ingredient|
        {
          name: ingredient.at('span')&.text.strip,
          quantity: ingredient.at('bdi')&.text.strip
        }
      end
      @steps = page.search('#steps ol li.step').map do |step|
        {
          number: step.at('.flex-shrink-0')&.text.strip,
          instruction: step.at('p')&.text.strip
        }
      end
    when /delishkitchen/
      lead_text = page.at('.title-box .lead').text.strip
      title_text = page.at('.title-box .title').text.strip
      @title = "#{lead_text} #{title_text}"  # レシピタイトル
      @image_url = page.at('.video-player video')['poster']  # レシピ画像URL
      @ingredients = page.search('.ingredient-list li.ingredient').map do |ingredient|
        {
          name: ingredient.at('.ingredient-name')&.text.strip,
          quantity: ingredient.at('.ingredient-serving')&.text.strip
        }
      end
      @steps = page.search('ol.steps li.step').map do |step|
        {
          number: step.at('.step-num')&.text.strip,
          instruction: step.at('.step-desc')&.text.strip
        }
      end
    when /kurashiru/
      title_text = page.at('.title-wrapper .title').text.strip
      @title = title_text.gsub(/　レシピ・作り方$/, '')  # レシピタイトル
      @image_url = page.at('.video-wrapper .video video')['poster']  # レシピ画像URL
      @ingredients = page.search('.ingredient-list li.ingredient-list-item').filter_map do |ingredient|
        next if ingredient['class'].include?('group-title')

        {
          name: ingredient.at('.ingredient-name')&.text.strip,
          quantity: ingredient.at('.ingredient-quantity-amount')&.text.strip
        }
      end
      @steps = page.search('ol.instruction-list li.instruction-list-item').map do |step|
        {
          number: step.at('.sort-order')&.text.strip.gsub('.', ''),
          instruction: step.at('.content')&.text.strip
        }
      end
    else
      raise '詳細情報を取得できませんでした'
    end
  end

  def save_options; end

  def auto_save
    @recipe = Recipe.new
  end

  def save_recipe
    url = params[:recipe][:source_url]
    if url.present?
      fetch_recipe_params = {source_url: url}
      fetch_recipe
    else
      flash[:danger] = t('.missing_url')
      redirect_to request.referer || root_path
    end
  end

  def fetch_recipe
    service = scraper_for(fetch_recipe_params[:source_url]) # 入力されたsource_urlをscraper_forメソッドに渡す
    basic_info = service.fetch_basic_info # serviceオブジェクトのfetch_basic_infoメソッドを呼び出し
    ingredients_and_instructions = service.fetch_ingredients_and_instructions # serviceオブジェクトのfetch_ingredients_and_instructionメソッドを呼び出し

    @recipe = Recipe.find_or_initialize_by(source_url: basic_info[:source_url], user_id: current_user.id) # URLに基づいてレシピを見つけるまたは新規作成

    if @recipe.persisted? # レシピが既に存在するか確認
      if @recipe.update_existing_recipe(current_user, basic_info, ingredients_and_instructions) # モデルのメソッドを呼び出す
        redirect_to recipes_path, success: t('.update_success')
      else
        flash.now[:danger] = t('.update_failure')
        render :auto_save, status: :unprocessable_entity
      end
    elsif @recipe.create_new_recipe(current_user, basic_info, ingredients_and_instructions) # モデルのメソッドを呼び出す
      redirect_to recipes_path, success: t('.success')
    else
      @recipe = current_user.recipes.build(title: basic_info[:title], source_url: basic_info[:source_url])
      flash.now[:danger] = t('.failure')
      render :auto_save, status: :unprocessable_entity
    end
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

  def index
    @q = current_user.recipes.ransack(params[:q])
    @recipes = @q.result(distinct: true).includes(:ingredients).order(created_at: :desc)
  end

  def show
    @recipe = Recipe.find(params[:id])
    image_url_with_params = @recipe.image.url # S3の画像URLを取得
    image_url = URI.parse(image_url_with_params).tap { |uri| uri.query = nil }.to_s # クエリパラメータを取り除く

    set_meta_tags(
      title: @recipe.title,
      description: "このレシピでは、#{@recipe.title}を作るための詳細な手順を紹介します。必要な材料や調理方法をチェックして、美味しい料理を楽しんでください！",
      og: {
        title: @recipe.title,
        description: "このレシピでは、#{@recipe.title}を作るための詳細な手順を紹介します。必要な材料や調理方法をチェックして、美味しい料理を楽しんでください！",
        type: 'article',
        url: request.original_url,
        image: image_url # レシピに関連する画像
      },
      twitter: {
        card: 'summary'
      }
    )
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

  # 自動保存時の入力URL
  def fetch_recipe_params
    params.require(:recipe).permit(:source_url)
  end

  # 手動保存時
  def recipe_params
    params.require(:recipe).permit(:title, :image, :image_cache, ingredients_attributes: [:id, :name, :quantity, :unit, :_destroy], instructions_attributes: [:id, :step_number, :description, :_destroy])
  end

  # 対応するスクレイピングサービスオブジェクトを選択
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

  # 作り方の手順番号を1から1ずつ増やす設定
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

  # クックパッドのスクレイピング処理
  def scrape_cookpad(query)
    agent = Mechanize.new
    recipes = []
    search_url = "https://cookpad.com/jp/search/#{CGI.escape(query)}?event=search.history&order=recent"
    page = agent.get(search_url)

    page.search('#search-recipes-list li[data-search-tracking-target="result"]').each do |recipe_element|
      title_element = recipe_element.at('h2 a')
      next unless title_element

      title = title_element.text.strip
      source_url = "https://cookpad.com" + title_element['href']
      recipes << { title: title, source_url: source_url, site_name: 'Cookpad' }
    end
    recipes
  end

  # DELISH KITCHENのスクレイピング処理
  def scrape_delish_kitchen(query)
    agent = Mechanize.new
    recipes = []
    search_url = "https://delishkitchen.tv/search?q=#{CGI.escape(query)}"
    page = agent.get(search_url)

    page.search('.delish-recipes .delish-recipe-item-card').each do |recipe_element|
      title_element = recipe_element.at('.item-card__title')
      next unless title_element

      title = title_element.text.strip
      source_url = "https://delishkitchen.tv" + recipe_element.at('a')['href']
      recipes << { title: title, source_url: source_url, site_name: 'DELISH KITCHEN' }
    end
    recipes
  end

  # クラシルのスクレイピング処理
  def scrape_kurashiru(query)
    agent = Mechanize.new
    recipes = []
    search_url = "https://kurashiru.com/search?query=#{CGI.escape(query)}"
    page = agent.get(search_url)

    page.search('.DlyMasonry-container .DlyMasonry-content').each do |recipe_element|
      title_element = recipe_element.at('.video-list-title a.title')
      next unless title_element

      title = title_element.text.strip
      source_url = "https://kurashiru.com" + recipe_element.at('a.thumbnail-wrapper')['href']
      recipes << { title: title, source_url: source_url, site_name: 'クラシル' }
    end
    recipes
  end
end
