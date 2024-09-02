module RecipeScrapers
  class CookpadScraper < RecipeScraper
    private

    def fetch_title
      @page.at('h1.break-words').text.strip
    end

    def fetch_image_url
      @page.at('picture img')['src']
    end

    def fetch_ingredients
      @page.search('.ingredient-list ol li').map do |ingredient_list|
        name = ingredient_list.at('span').text.strip
        quantity_text = ingredient_list.at('bdi').text.strip
        quantity, unit = Recipe.parse_quantity_and_unit(quantity_text) # モデルのメソッドを呼び出す
        { name:, quantity:, unit: }
      end
    end

    def fetch_instructions
      @page.search('ol.list-none li.step').each_with_index.map do |step, index|
        description = step.at('p').text.strip
        { step_number: index + 1, description: }
      end
    end
  end
end
