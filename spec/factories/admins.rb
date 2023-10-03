FactoryBot.define do
  factory :admin, parent: :user, class: 'Admin' do
    user_type { 'Admin' }
  end
end