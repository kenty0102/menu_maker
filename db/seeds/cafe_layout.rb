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
  "menu-title" => {
    "text-align" => "center",
    "font-size" => "70px",
    "margin-bottom" => "50px"
  },
  "title-under" => {
    "background-image" => "url('/assets/cafe_image_title.png')",
    "background-repeat" => "no-repeat",
    "background-position" => "center",
    "background-size" => "100% 100%",
    "padding-bottom" => "10rem"
  },
  "main-container" => {
    "display" => "flex",
    "width" => "100%"
  },
  "illustration-pot" => {
    "background-image" => "url('/assets/cafe_image_pot.png')",
    "background-size" => "100%",
    "background-repeat" => "no-repeat",
    "width" => "350px",
    "height" => "350px"
  },
  "menu-recipes" => {
    "font-size" => "50px",
    "padding" => "30px 0",
    "text-align" => "center"
  },
  "recipe-title" => {
    "margin-top" => "50px"
  },
  "illustration-spoon" => {
    "background-image" => "url('/assets/cafe_image_spoon.png')",
    "background-size" => "100%",
    "background-repeat" => "no-repeat",
    "width" => "320px",
    "height" => "320px",
    "margin-top" => "10rem"
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
    "width" => "260px",
    "height" => "260px",
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
    "smartphone" => {
      "media" => "max-width: 767px",
      "styles" => {
        ".menu-container" => {
          "padding" => "0.5rem",
          "margin-bottom" => "0"
        },
        ".top-decoration-left" => {
          "width" => "100px",
          "height" => "100px"
        },
        ".top-decoration-center" => {
          "width" => "70px",
          "height" => "70px",
          "padding-bottom" => "2rem"
        },
        ".top-decoration-right" => {
          "width" => "120px",
          "height" => "120px"
        },
        ".menu-title" => {
          "font-size" => "20px",
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
          "padding-left" => "1.5rem",
          "padding-right" => "1.5rem",
          "margin-top" => "1.5rem"
        },
        ".illustration-pot" => {
          "width" => "120px",
          "height" => "120px",
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
    },
    "tablet" => {
      "media" => "min-width: 768px and max-width: 992px",
      "styles" => {
        ".menu-container" => {
          "padding" => "0.5rem",
          "margin-bottom" => "0"
        },
        ".top-decoration-left" => {
          "width" => "200px",
          "height" => "200px"
        },
        ".top-decoration-center" => {
          "width" => "150px",
          "height" => "150px",
          "padding-bottom" => "2rem"
        },
        ".top-decoration-right" => {
          "width" => "220px",
          "height" => "220px"
        },
        ".menu-title" => {
          "font-size" => "60px",
          "margin-bottom" => "1rem"
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
          "margin-top" => "1.5rem"
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
          "width" => "250px",
          "height" => "250px",
          "margin-right" => "1.5rem"
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
