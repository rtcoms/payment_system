require 'rails_helper'

RSpec.describe Admin, type: :model do
  it "is valid with valid attributes" do
    admin = build(:admin)
    expect(admin).to be_valid
  end

  # Add more tests specific to Admin if needed
end
