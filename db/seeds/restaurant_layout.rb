restaurant_layout = {
  "font-face" => {
    "font-family" => "MyCustomFont",
    "src" => "url('/assets/ShipporiMincho-Regular.ttf') format('opentype')",
    "font-weight" => "normal",
    "font-style" => "normal"
  },
  "body" => {
    "background-color" => "#f5f1ed",
    "font-family" => ["MyCustomFont", "凸版文久見出し明朝"],
    "color" => "#b2935b",
    "margin" => "0",
    "padding" => "0"
  },
  "menu-container" => {
    "max-width" => "1200px",
    "margin" => "0 auto",
    "padding" => "0.5rem 0.5rem"
  },
  "top-decoration-container" => {
    "display" => "flex",
    "justify-content" => "space-between",
    "align-items" => "top",
    "width" => "100%",
    "height" => "425px"
  },
  "top-decoration-left" => {
    "background-image" => "url('/assets/restaurant_image_top_left.png')",
    "background-size" => "100%",
    "background-repeat" => "no-repeat",
    "width" => "300px",
    "height" => "300px"
  },
  "top-decoration-center" => {
    "background-image" => "url('/assets/restaurant_image_top_logo.png')",
    "background-size" => "100%",
    "background-repeat" => "no-repeat",
    "width" => "500px",
    "height" => "500px"
  },
  "top-decoration-right" => {
    "background-image" => "url('/assets/restaurant_image_top_right.png')",
    "background-size" => "100%",
    "background-repeat" => "no-repeat",
    "width" => "300px",
    "height" => "300px"
  },
  "menu-title" => {
    "text-align" => "center",
    "font-size" => "70px",
    "margin-bottom" => "10rem"
  },
  "title-under" => {
    "background-image" => "url('/assets/restaurant_image_title.png')",
    "background-repeat" => "no-repeat",
    "background-position" => "center",
    "background-size" => "100% 200%",
    "padding-bottom" => "10rem"
  },
  "main-container" => {
    "padding" => "0 12rem"
  },
  "menu-recipes" => {
    "font-size" => "50px",
    "padding-top" => "30px",
    "text-align" => "start"
  },
  "recipe-title" => {
    "margin-top" => "50px"
  },
  "recipe-note" => {
    "font-size" => "30px"
  },
  "bottom-decoration-container" => {
    "display" => "flex",
    "justify-content" => "space-between",
    "align-items" => "bottom",
    "width" => "100%"
  },
  "bottom-decoration-left" => {
    "background-image" => "url('/assets/restaurant_image_bottom_left.png')",
    "background-size" => "100%",
    "background-repeat" => "no-repeat",
    "width" => "300px",
    "height" => "300px"
  },
  "bottom-decoration-right" => {
    "background-image" => "url('/assets/restaurant_image_bottom_right.png')",
    "background-size" => "100%",
    "background-repeat" => "no-repeat",
    "width" => "300px",
    "height" => "300px"
  },
  "media-queries" => {
    "tablet" => {
      "media" => "min-width: 768px and max-width: 992px",
      "styles" => {
        ".menu-container" => {
          "padding" => "0.5rem"
        },
        ".top-decoration-container" => {
          "height" => "300px"
        },
        ".top-decoration-left" => {
          "width" => "200px",
          "height" => "200px"
        },
        ".top-decoration-center" => {
          "width" => "350px",
          "height" => "350px",
          "padding-bottom" => "2rem"
        },
        ".top-decoration-right" => {
          "width" => "200px",
          "height" => "200px"
        },
        ".menu-title" => {
          "font-size" => "50px",
          "margin-bottom" => "5rem"
        },
        ".title-under" => {
          "padding-bottom" => "6rem"
        },
        ".main-container" => {
          "padding" => "0 7rem"
        },
        ".menu-recipes" => {
          "padding-top" => "0",
          "padding-bottom" => "0"
        },
        ".recipe-title" => {
          "font-size" => "30px",
          "padding-left" => "1.5rem",
          "padding-right" => "1.5rem",
          "margin-top" => "1.5rem"
        },
        ".recipe-note" => {
          "font-size" => "20px"
        },
        ".bottom-decoration-left" => {
          "width" => "200px",
          "height" => "200px"
        },
        ".bottom-decoration-right" => {
          "width" => "200px",
          "height" => "200px"
        }
      }
    },
    "smartphone" => {
      "media" => "max-width: 767px",
      "styles" => {
        ".menu-container" => {
          "padding" => "0.3rem",
          "margin-bottom" => "0"
        },
        ".top-decoration-container" => {
          "height" => "150px"
        },
        ".top-decoration-left" => {
          "width" => "100px",
          "height" => "100px"
        },
        ".top-decoration-center" => {
          "width" => "160px",
          "height" => "160px",
          "padding-bottom" => "2rem"
        },
        ".top-decoration-right" => {
          "width" => "100px",
          "height" => "100px"
        },
        ".menu-title" => {
          "font-size" => "20px",
          "margin-bottom" => "3rem"
        },
        ".title-under" => {
          "padding-bottom" => "3rem"
        },
        ".main-container" => {
          "padding" => "0 2rem"
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
        "recipe-note" => {
          "font-size" => "10px"
        },
        ".recipe-note" => {
          "font-size" => "9px"
        },
        ".bottom-decoration-left" => {
          "width" => "100px",
          "height" => "100px"
        },
        ".bottom-decoration-right" => {
          "width" => "100px",
          "height" => "100px"
        }
      }
    }
  }
}

design = Design.find_by(name: 'レストラン風メニュー')
if design
  design.update!(layout: restaurant_layout.to_json)
else
  Design.create!(
    name: 'レストラン風メニュー',
    layout: restaurant_layout.to_json
  )
end