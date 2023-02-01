FactoryBot.define do
  factory :post do
    content { Faker::ChuckNorris.fact }
    association :user, factory: :user
  end
end
