# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
izakaya_layout = {
  "font-face" => {
    "font-family" => "MyCustomFont",
    "src" => "url('/assets/Ounen-mouhitsu.otf') format('opentype')",
    "font-weight" => "normal",
    "font-style" => "normal"
  },
  "body" => {
    "background-image" => "url('/assets/izakaya_image_background.png')",
    "font-family" => ["MyCustomFont", "凸版文久見出し明朝"],
    "color" => "#000000"
  },
  "menu-container" => {
    "width" => "100%",
    "max-width" => "800px",
    "margin" => "0 auto",
    "padding" => "50px 50px"
  },
  "menu-title" => {
    "text-align" => "center",
    "font-size" => "70px",
    "margin-bottom" => "40px"
  },
  "title-under" => {
    "background-image" => "url('/assets/izakaya_image_title.png')",
    "background-repeat" => "no-repeat",
    "background-position" => "center",
    "background-size" => "200% 180%",
    "padding-bottom" => "1.7em"
  },
  "menu-recipes" => {
    "font-size" => "40px",
    "padding" => "30px 0"
  },
  "recipe-title" => {
    "margin-top" => "50px"
  },
  "under" => {
    "background-image" => "url('/assets/izakaya_image_underbar.png')",
    "background-repeat" => "no-repeat",
    "background-position" => "center",
    "background-size" => "300% 300%",
    "padding-bottom" => "0.7em"
  },
  "illustrations-container" => {
    "display" => "flex",
    "justify-content" => "space-between",
    "padding" => "0 50px",
    "margin-bottom" => "50px"
  },
  "illustration-curry" => {
    "height" => "200px",
    "width" => "400px",
    "background-size" => "180% 250%",
    "background-image" => "url('/assets/izakaya_image_curry.png')",
    "background-repeat" => "no-repeat",
    "background-position" => "center",
    "margin-top" => "1em",
    "transform" => "rotate(5deg)"
  },
  "illustration-onigiri" => {
    "height" => "200px",
    "width" => "400px",
    "background-size" => "180% 250%",
    "background-image" => "url('/assets/izakaya_image_onigiri.png')",
    "background-repeat" => "no-repeat",
    "background-position" => "center",
    "margin-top" => "1em",
    "transform" => "rotate(-10deg)"
  }
}

design = Design.find_by(name: '居酒屋風メニュー')
if design
  design.update!(layout: izakaya_layout.to_json)
else
  Design.create!(
    name: '居酒屋風メニュー',
    layout: izakaya_layout.to_json
  )
end
