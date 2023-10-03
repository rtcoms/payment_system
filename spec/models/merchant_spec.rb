require 'rails_helper'

RSpec.describe Merchant, type: :model do
  it "is valid with valid attributes" do
    merchant = build(:merchant)
    expect(merchant).to be_valid
  end
end

