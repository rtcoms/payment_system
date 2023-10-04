FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    user_type { 'User' }
    password { 'password' }
    password_confirmation { 'password' }
    name { Faker::Name.name }
    description { Faker::Lorem.paragraph }
    total_transaction_sum { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
    status { 'active' }

    trait :inactive do
      status { 'inactive' }
    end
  end
end
