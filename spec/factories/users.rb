FactoryBot.define do
  factory :user do
    email { Faker::Internet.email(name: "#{first_name} #{last_name}").downcase }
    username { "#{first_name[0]}#{last_name}#{Faker::Number.number(digits: 3)}".downcase }
    password { 'default' }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
  end
end
