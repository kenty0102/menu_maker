FactoryBot.define do
  factory :design do
    name { "居酒屋風メニュー" }
    layout { { "menu-title" => { "position" => "top", "font-size" => "24px" }, "recipe-title" => { "position" => "middle", "font-size" => "18px" } }.to_json }
  end
end
