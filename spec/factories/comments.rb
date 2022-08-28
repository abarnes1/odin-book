FactoryBot.define do
  factory :comment do
    message { 'Default comment' }
    user { nil }
    post { nil }
  end
end
