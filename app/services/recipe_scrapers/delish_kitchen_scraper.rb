module RecipeScrapers
  class DelishKitchenScraper < RecipeScraper
    private

    def fetch_title
      lead_text = @page.search('.title-box .lead').text.strip
      title_text = @page.search('.title-box .title').text.strip
      "#{lead_text} #{title_text}"
    end

    def fetch_image_url
      @page.search('.video-player video').attr('poster').value
    end

    def fetch_ingredients
      @page.search('.ingredient-list li.ingredient').map do |ingredient_list|
        name = ingredient_list.at('.ingredient-name').text.strip
        quantity_text = ingredient_list.at('.ingredient-serving').text.strip
        quantity, unit = Recipe.parse_quantity_and_unit(quantity_text)
        { name:, quantity:, unit: }
      end
    end

    def fetch_instructions
      @page.search('ol.steps li.step').each_with_index.map do |step, index|
        description = step.at('.step-desc').text.strip
        { step_number: index + 1, description: }
      end
    end
  end
end
