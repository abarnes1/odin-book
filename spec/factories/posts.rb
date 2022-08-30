FactoryBot.define do
  factory :post do
    content { Faker::ChuckNorris.fact }
    user { nil }
  end
end
