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
  },
  "media-queries" => {
    "smartphone" => {
      "media" => "max-width: 768px",
      "styles" => {
        ".menu-container" => {
          "padding-left" => "1rem",
          "padding-right" => "1rem",
          "padding-top" => "1.5rem",
          "padding-bottom" => "0",
          "margin-bottom" => "0"
        },
        ".menu-title" => {
          "font-size" => "25px",
          "margin-bottom" => "2.5rem"
        },
        ".menu-recipes" => {
          "padding-top" => "0",
          "padding-bottom" => "0"
        },
        ".recipe-title" => {
          "font-size" => "15px",
          "padding-left" => "1.5rem",
          "padding-right" => "1.5rem",
          "margin-top" => "1.5rem"
        },
        ".illustration-curry" => {
          "width" => "120px",
          "height" => "60px"
        },
        ".illustrations-container" => {
          "padding-left" => "1.5rem",
          "padding-right" => "1.5rem",
          "padding-top" => "1rem",
          "padding-bottom" => "0.5rem",
          "margin-bottom" => "0"
        },
        ".illustration-onigiri" => {
          "width" => "120px",
          "height" => "60px"
        }
      }
    },
    "tablet" => {
      "media" => "min-width: 768px and max-width: 992px",
      "styles" => {
        ".menu-container" => {
          "padding-left" => "2rem",
          "padding-right" => "2rem",
          "padding-top" => "1.5rem",
          "padding-bottom" => "0",
          "margin-bottom" => "0"
        },
        ".menu-title" => {
          "font-size" => "50px",
          "margin-bottom" => "3.5rem"
        },
        ".menu-recipes" => {
          "padding-top" => "0",
          "padding-bottom" => "0"
        },
        ".recipe-title" => {
          "font-size" => "35px",
          "padding-left" => "1.5rem",
          "padding-right" => "1.5rem",
          "margin-top" => "1.5rem"
        },
        ".illustration-curry" => {
          "width" => "200px",
          "height" => "100px"
        },
        ".illustrations-container" => {
          "padding-left" => "2rem",
          "padding-right" => "2rem",
          "padding-top" => "1rem",
          "padding-bottom" => "1rem",
          "margin-bottom" => "1rem"
        },
        ".illustration-onigiri" => {
          "width" => "200px",
          "height" => "100px"
        }
      }
    }
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