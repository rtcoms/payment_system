FactoryBot.define do
  factory :api_token do
    # association :merchant, factory: :merchant
    merchant { create(:merchant) }
  end
end
