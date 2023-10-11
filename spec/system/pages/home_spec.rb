require "rails_helper"

RSpec.describe 'Home Page' do
  describe 'Display home page' do
    it 'should have payment system brand name' do
      visit '/'
     
      expect(find('.navbar-brand')).to have_text('Payment System')
    end
  end
end