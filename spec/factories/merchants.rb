FactoryBot.define do
  factory :merchant, parent: :user, class: 'Merchant' do
    user_type { 'Merchant' }
  end
end