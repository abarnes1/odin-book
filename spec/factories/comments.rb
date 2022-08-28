FactoryBot.define do
  factory :comment do
    content { 'Default comment' }
    user { nil }
    post { nil }
  end
end
