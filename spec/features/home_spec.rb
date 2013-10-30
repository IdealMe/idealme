#require 'spec_helper'
#
#describe 'home page' do
#  it 'welcomes the user', js: true do
#    visit '/'
#    page.should have_content('Ideal Me')
#  end
#
#  after(:each) do
#    path = "#{Rails.root}/build/screenshots/" + example.metadata[:full_description].gsub(" ", "_")+".png"
#    page.driver.browser.save_screenshot(path)
#  end
#end
#
