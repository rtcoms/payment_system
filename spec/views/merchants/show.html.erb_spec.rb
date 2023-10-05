require 'rails_helper'

RSpec.describe "merchants/show", type: :view do
  before(:each) do
    assign(:merchant, Merchant.create!(
      name: "Name",
      email: "Email",
      description: "MyText",
      password: "Password",
      password_confirmation: "Password Confirmation",
      status: "Status"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Password/)
    expect(rendered).to match(/Password Confirmation/)
    expect(rendered).to match(/Status/)
  end
end
