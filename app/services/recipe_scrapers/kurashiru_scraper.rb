module RecipeScrapers
  class KurashiruScraper < RecipeScraper
    private

    def fetch_title
      title_text = @page.at('.title-wrapper .title').text.strip
      title_text.gsub(/　レシピ・作り方$/, '') # 「レシピ・作り方」を取り除く
    end

    def fetch_image_url
      @page.at('.video-wrapper .video video')['poster']
    end

    def fetch_ingredients
      @page.search('.ingredient-list li.ingredient-list-item').filter_map do |ingredient_list| # filter_mapで条件を満たす要素のみをマップして返す
        next if ingredient_list['class'].include?('group-title') # group-titleが含まれている要素をスキップ

        name = ingredient_list.at('.ingredient-name').text.strip
        quantity_text = ingredient_list.at('.ingredient-quantity-amount').text.strip
        quantity, unit = Recipe.parse_quantity_and_unit(quantity_text) # モデルのメソッドを呼び出す
        { name:, quantity:, unit: }
      end
    end

    def fetch_instructions
      @page.search('ol.instruction-list li.instruction-list-item').each_with_index.map do |step, index|
        description = step.at('.content').text.strip
        { step_number: index + 1, description: }
      end
    end
  end
end
