FactoryBot.define do
  factory :recipe do
    user { nil }
    title { "MyString" }
    image_url { "MyString" }
    source_url { "MyString" }
    source_site_name { "MyString" }
    scraped_at { "2024-07-12 10:15:55" }
  end
end
