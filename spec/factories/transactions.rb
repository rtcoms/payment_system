FactoryBot.define do
  factory :transaction do
    uuid { SecureRandom.uuid }
    amount { 100.00 }
    status { 'approved' }
    customer_email { Faker::Internet.email }
    customer_phone { Faker::PhoneNumber.phone_number }
    merchant { association :merchant } # Assuming you have a Merchant factory
  end
end