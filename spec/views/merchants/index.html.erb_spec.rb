require 'rails_helper'

RSpec.describe "merchants/index", type: :view do
  before(:each) do
    assign(:merchants, [
      Merchant.create!(
        name: "Name",
        email: "Email",
        description: "MyText",
        password: "Password",
        password_confirmation: "Password Confirmation",
        status: "Status"
      ),
      Merchant.create!(
        name: "Name",
        email: "Email",
        description: "MyText",
        password: "Password",
        password_confirmation: "Password Confirmation",
        status: "Status"
      )
    ])
  end

  it "renders a list of merchants" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Email".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Password".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Password Confirmation".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Status".to_s), count: 2
  end
end
