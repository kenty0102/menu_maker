cafe_layout = {
  "font-face" => {
    "font-family" => "MyCustomFont",
    "src" => "url('/assets/Chalk-JP.otf') format('opentype')",
    "font-weight" => "normal",
    "font-style" => "normal"
  },
  "body" => {
    "background-image" => "url('/assets/cafe_image_background.png')",
    "font-family" => ["MyCustomFont", "凸版文久見出し明朝"],
    "color" => "#f0f0f0",
    "background-size" => "cover",
    "background-repeat" => "no-repeat",
    "background-position" => "center",
    "margin" => "0",
    "padding" => "0"
  },
  "menu-container" => {
    "max-width" => "1200px",
    "margin" => "0 auto",
    "padding" => "1rem 1.5rem"
  },
  "top-decoration-container" => {
    "display" => "flex",
    "justify-content" => "space-between",
    "align-items" => "center",
    "width" => "100%"
  },
  "top-decoration-left" => {
    "background-image" => "url('/assets/cafe_image_leaf_left.png')",
    "background-size" => "100%",
    "background-repeat" => "no-repeat",
    "width" => "300px",
    "height" => "300px"
  },
  "top-decoration-center" => {
    "background-image" => "url('/assets/cafe_image_app_logo.png')",
    "background-size" => "100%",
    "background-repeat" => "no-repeat",
    "width" => "250px",
    "height" => "250px",
    "padding-bottom" => "5rem"
  },
  "top-decoration-right" => {
    "background-image" => "url('/assets/cafe_image_leaf_right.png')",
    "background-size" => "100%",
    "background-repeat" => "no-repeat",
    "width" => "320px",
    "height" => "320px"
  },
  "main-container" => {
    "display" => "flex",
    "justify-content" => "space-between",
    "align-items" => "center",
    "width" => "100%"
  },
  "menu-title" => {
    "text-align" => "center",
    "font-size" => "60px",
    "margin-bottom" => "4rem"
  },
  "title-under" => {
    "background-image" => "url('/assets/cafe_image_title.png')",
    "background-repeat" => "no-repeat",
    "background-position" => "center",
    "background-size" => "100% 100%",
    "padding-bottom" => "8rem"
  },
  "illustration-pot" => {
    "background-image" => "url('/assets/cafe_image_pot.png')",
    "background-size" => "100%",
    "background-repeat" => "no-repeat",
    "width" => "300px",
    "height" => "300px",
    "margin-top" => "7rem"
  },
  "menu-recipes" => {
    "font-size" => "45px",
    "padding" => "2rem 0",
    "text-align" => "center"
  },
  "recipe-title" => {
    "margin-top" => "2rem"
  },
  "recipe-note" => {
    "font-size" => "30px"
  },
  "illustration-spoon" => {
    "background-image" => "url('/assets/cafe_image_spoon.png')",
    "background-size" => "100%",
    "background-repeat" => "no-repeat",
    "width" => "280px",
    "height" => "280px",
    "margin-top" => "18rem"
  },
  "illustrations-container" => {
    "display" => "flex",
    "justify-content" => "space-between"
  },
  "illustration-fork" => {
    "background-image" => "url('/assets/cafe_image_fork.png')",
    "background-size" => "100% 100%",
    "background-repeat" => "no-repeat",
    "background-position" => "top",
    "width" => "240px",
    "height" => "240px",
    "margin-bottom" => "1rem",
    "margin-left" => "1rem"
  },
  "illustration-coffee" => {
    "background-image" => "url('/assets/cafe_image_coffee.png')",
    "background-size" => "100% 100%",
    "background-repeat" => "no-repeat",
    "background-position" => "top",
    "width" => "450px",
    "height" => "400px",
    "margin-right" => "3rem"
  },
  "media-queries" => {
    "tablet" => {
      "media" => "min-width: 696px and max-width: 936px",
      "styles" => {
        ".menu-container" => {
          "padding" => "0.5rem",
          "margin-bottom" => "0"
        },
        ".top-decoration-left" => {
          "width" => "180px",
          "height" => "180px"
        },
        ".top-decoration-center" => {
          "width" => "150px",
          "height" => "150px",
          "padding-bottom" => "2rem"
        },
        ".top-decoration-right" => {
          "width" => "200px",
          "height" => "200px"
        },
        ".menu-title" => {
          "font-size" => "50px",
          "margin-bottom" => "3rem"
        },
        ".title-under" => {
          "padding-bottom" => "6rem"
        },
        ".menu-recipes" => {
          "padding-top" => "0",
          "padding-bottom" => "0"
        },
        ".recipe-title" => {
          "font-size" => "30px",
          "padding" => "0 0.5rem",
          "margin-top" => "2rem"
        },
        ".recipe-note" => {
          "font-size" => "18px",
          "margin-top" => "0"
        },
        ".illustration-pot" => {
          "width" => "180px",
          "height" => "180px",
          "margin-left" => "0.5rem"
        },
        ".under" => {
          "padding-bottom" => "3rem"
        },
        ".illustration-spoon" => {
          "width" => "150px",
          "height" => "150px",
          "margin-top" => "4rem"
        },
        ".illustration-fork" => {
          "width" => "150px",
          "height" => "150px",
          "margin-left" => "1.5rem"
        },
        ".illustration-coffee" => {
          "width" => "220px",
          "height" => "220px",
          "margin-right" => "1.5rem"
        }
      }
    },
    "smartphone" => {
      "media" => "max-width: 695px",
      "styles" => {
        ".menu-container" => {
          "padding" => "0.5rem",
          "margin-bottom" => "0"
        },
        ".top-decoration-left" => {
          "width" => "80px",
          "height" => "80px"
        },
        ".top-decoration-center" => {
          "width" => "70px",
          "height" => "70px",
          "padding-bottom" => "2rem"
        },
        ".top-decoration-right" => {
          "width" => "90px",
          "height" => "90px"
        },
        ".menu-title" => {
          "font-size" => "25px",
          "margin-bottom" => "1rem"
        },
        ".title-under" => {
          "padding-bottom" => "3rem"
        },
        ".menu-recipes" => {
          "padding-top" => "0",
          "padding-bottom" => "0"
        },
        ".recipe-title" => {
          "font-size" => "15px",
          "padding-left" => "0.5rem",
          "padding-right" => "0.5rem",
          "margin-top" => "1.5rem"
        },
        ".recipe-note" => {
          "font-size" => "10px"
        },
        ".illustration-pot" => {
          "width" => "100px",
          "height" => "100px",
          "margin-top" => "1rem",
          "margin-left" => "0.5rem"
        },
        ".under" => {
          "padding-bottom" => "1.5rem"
        },
        ".illustration-spoon" => {
          "width" => "100px",
          "height" => "100px",
          "margin-top" => "4rem"
        },
        ".illustration-fork" => {
          "width" => "70px",
          "height" => "70px",
          "margin-left" => "1.5rem"
        },
        ".illustration-coffee" => {
          "width" => "100px",
          "height" => "80px",
          "padding-top" => "1rem",
          "margin-right" => "1rem"
        }
      }
    }
  }
}

design = Design.find_by(name: 'カフェ風メニュー')
if design
  design.update!(layout: cafe_layout.to_json)
else
  Design.create!(
    name: 'カフェ風メニュー',
    layout: cafe_layout.to_json
  )
end
