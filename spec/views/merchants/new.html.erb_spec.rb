require 'rails_helper'

RSpec.describe "merchants/new", type: :view do
  before(:each) do
    assign(:merchant, Merchant.new(
      name: "MyString",
      email: "MyString",
      description: "MyText",
      password: "MyString",
      password_confirmation: "MyString",
      status: "MyString"
    ))
  end

  it "renders new merchant form" do
    render

    assert_select "form[action=?][method=?]", merchants_path, "post" do

      assert_select "input[name=?]", "merchant[name]"

      assert_select "input[name=?]", "merchant[email]"

      assert_select "textarea[name=?]", "merchant[description]"

      assert_select "input[name=?]", "merchant[password]"

      assert_select "input[name=?]", "merchant[password_confirmation]"

      assert_select "input[name=?]", "merchant[status]"
    end
  end
end
