# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
izakaya_layout = {
  "fontFace": {
    "fontFamily": "MyCustomFont",
    "src": "url('/assets/Ounen-mouhitsu.otf') format('opentype')",
    "fontWeight": "normal",
    "fontStyle": "normal"
  },
  "body": {
    "backgroundImage": "url('/assets/izakaya_image_background.png')",
    "fontFamily": ["MyCustomFont", "凸版文久見出し明朝"],
    "color": "#000000"
  },
  "menuContainer": {
    "width": "100%",
    "maxWidth": "800px",
    "margin": "0 auto",
    "padding": "50px 50px"
  },
  "titleUnder": {
    "backgroundImage": "url('/assets/izakaya_image_title.png')",
    "backgroundRepeat": "no-repeat",
    "backgroundPosition": "center",
    "backgroundSize": "200% 180%",
    "paddingBottom": "1.7em",
    "title": "{menu_title}"  # プレースホルダー
  },
  "menuTitle": {
    "textAlign": "center",
    "fontSize": "100px",
    "marginBottom": "50px"
  },
  "menuRecipes": {
    "fontSize": "55px",
    "padding": "30px 0"
  },
  "recipeTitle": {
    "marginTop": "50px",
    "recipe_titles": ["{recipe_titles}"]  # プレースホルダー
  },
  "under": {
    "backgroundImage": "url('/assets/izakaya_image_underbar.png')",
    "backgroundRepeat": "no-repeat",
    "backgroundPosition": "center",
    "backgroundSize": "300% 300%",
    "paddingBottom": "0.7em"
  },
  "illustrationsContainer": {
    "display": "flex",
    "justifyContent": "space-between",
    "padding": "0 50px",
    "marginBottom": "50px"
  },
  "illustrationCurry": {
    "height": "200px",
    "width": "400px",
    "backgroundSize": "180% 250%",
    "backgroundImage": "url('/assets/izakaya_image_curry.png')",
    "backgroundRepeat": "no-repeat",
    "backgroundPosition": "center",
    "marginTop": "1em",
    "transform": "rotate(5deg)"
  },
  "illustrationOnigiri": {
    "height": "200px",
    "width": "400px",
    "backgroundSize": "180% 250%",
    "backgroundImage": "url('/assets/izakaya_image_onigiri.png')",
    "backgroundRepeat": "no-repeat",
    "backgroundPosition": "center",
    "marginTop": "1em",
    "transform": "rotate(-10deg)"
  }
}

# デザインデータをデータベースに保存
Design.create!(
  name: '居酒屋風メニュー',
  layout: izakaya_layout.to_json
)
