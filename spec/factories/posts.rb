FactoryBot.define do
  factory :post do
    content { 'Default post content' }
    user { nil }
  end
end
