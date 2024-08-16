module RecipeScrapers
  class RecipeScraper
    def initialize(url)
      @url = url
      @agent = Mechanize.new # Mechanizeクラスをインスタンス化
      @page = @agent.get(@url) # 入力されたURLからWebページを取得
    end

    def fetch_basic_info
      {
        title: fetch_title,
        image_url: fetch_image_url,
        source_url: @url,
        source_site_name: determine_source_site_name(@url),
        scraped_at: Time.current
      }
    end

    def fetch_ingredients_and_instructions
      {
        ingredients: fetch_ingredients,
        instructions: fetch_instructions
      }
    end

    private

    def determine_source_site_name(url)
      case URI.parse(url).host # URLを解析＆解析したURLのホスト名（ドメイン）を取得し、取得したホスト名についての条件分岐
      when 'cookpad.com'
        'Cookpad' # ホスト名が'cookpad.com'のときに'Cookpad'を返す
      when 'delishkitchen.tv'
        'DELISH KITCHEN'
      else
        host # 条件に当てはまらない場合は、ホスト名をそのまま返す
      end
    end
  end
end
