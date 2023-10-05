require 'rails_helper'

RSpec.describe "merchants/edit", type: :view do
  let(:merchant) {
    Merchant.create!(
      name: "MyString",
      email: "MyString",
      description: "MyText",
      password: "MyString",
      password_confirmation: "MyString",
      status: "MyString"
    )
  }

  before(:each) do
    assign(:merchant, merchant)
  end

  it "renders the edit merchant form" do
    render

    assert_select "form[action=?][method=?]", merchant_path(merchant), "post" do

      assert_select "input[name=?]", "merchant[name]"

      assert_select "input[name=?]", "merchant[email]"

      assert_select "textarea[name=?]", "merchant[description]"

      assert_select "input[name=?]", "merchant[password]"

      assert_select "input[name=?]", "merchant[password_confirmation]"

      assert_select "input[name=?]", "merchant[status]"
    end
  end
end
