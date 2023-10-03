FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    encrypted_password { Devise.friendly_token }
    remember_created_at { nil }
    name { Faker::Name.name }
    description { Faker::Lorem.paragraph }
    total_transaction_sum { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
    status { 'active' }

    trait :inactive do
      status { 'inactive' }
    end
  end
end
