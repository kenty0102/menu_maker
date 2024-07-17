require 'faker'

FactoryBot.define do
  factory :recipe do
    association :user
    title { Faker::Food.dish }
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/sample.jpg'), 'image/jpg') }
    source_url { Faker::Internet.url }
    source_site_name { "Cookpad" }
    scraped_at { Time.current }
  end
end
