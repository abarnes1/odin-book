FactoryBot.define do
  factory :user do
    email { 'default@default.com' }
    username { 'defaultuser' }
    password { 'default' }
    first_name { 'firstname' }
    last_name { 'lastname' }
  end
end
