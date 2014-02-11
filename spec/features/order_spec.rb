require 'spec_helper'

describe 'ordering' do
  let!(:link)               { create(:affiliate_link) }
  let!(:affiliate_user)     { link.user }
  let!(:market)             { create(:market, course: course) }
  let!(:course)             { create(:course, owner: affiliate_user) }

  it "be logged in after set password", vcr: true, js: true do
    user = create(:user)
    user.update_attributes({
      :has_password => false,
      :identity_unlocked_at => 1.day.ago,
      :about => nil,
      :instructor_about => "",
      :notes => nil,
      :firstname => "Bean",
      :lastname => "Salad",
      :username => "beansalad",
      :timezone => "Etc/Zulu",
      :tagline => "",
      :affiliate_tag => nil,
      :affiliate_default_payment_id => nil,
      :affiliate_payment_frequency => nil,
      :access_normal => true,
      :access_affiliate => false,
      :access_instructor => false,
      :access_support => false,
      :access_admin => false,
      :avatar_file_name => nil,
      :avatar_content_type => nil,
      :avatar_file_size => nil,
      :avatar_updated_at => nil,
      :toured => false,
      :goal_count => 0,
      :course_count => 0,
      :email => "beansalad@idealme.com",
      :encrypted_password => "",
      :reset_password_token => nil,
      :reset_password_sent_at => nil,
      :remember_created_at => nil,
      :sign_in_count => 1,
      :current_sign_in_at => 1.day.ago,
      :last_sign_in_at => 1.day.ago,
      :current_sign_in_ip => "127.0.0.1",
      :last_sign_in_ip => "127.0.0.1",
      :confirmation_token => "437404a21d3788f98d1ef7b23aa63fd03786e7704d43bf2c79e6cbc4fec616d5",
      :confirmed_at => nil,
      :confirmation_sent_at => 1.day.ago,
      :unconfirmed_email => nil,
      :failed_attempts => 0,
      :unlock_token => nil,
      :locked_at => nil,
      :authentication_token => nil,
      :created_at => 1.day.ago,
      :updated_at => 1.day.ago,
      :fake => false,
      :welcome_message_dismissed => false,
      :added_to_aweber => nil
    })
    confirm_link = 'http://idealme.com/verification?confirmation_token=cAYhHTTLrPoBjqyUK72Q'

    uri = URI.parse(confirm_link)
    visit "#{uri.path}?#{uri.query}"

    fill_in "Password", with: "123123123"
    fill_in "Confirmation", with: "123123123"
    click_button "Activate"

    expect(current_path).to eq user_path(User.last)
  end

  it "enroll in course without a user account", vcr: true, js: true do
    User.count.should eq 1
    visit market_path market
    find('.top-enroll-btn').click
    current_path.should eq '/orders/new/sample-market'

    fill_in "Card Number", with: '4242424242424242'
    fill_in "Security Code", with: '123'
    click_button "Complete Purchase"
    sleep 5
    page.text.should include "First Name can't be blank"
    page.text.should include "Last Name can't be blank"
    page.text.should include "Email Address can't be blank"

    fill_in "First Name", with: "Bean"
    fill_in "Last Name", with: "Salad"
    fill_in "Email Address", with: "beansalad@idealme.com"
    fill_in "Card exp month", with: '01'
    fill_in "Card exp year", with: '2020'

    click_button "Complete Purchase"

    Timeout.timeout(10) do
      loop until current_path == '/orders'
    end

    visit course_path(course)
    sleep 0.3
    expect(current_path).to eq course_path(course)

    user = User.last
    Order.count.should eq 1
    Order.last.user.should eq user

    # open email, get link, go to confirm
    email = last_email
    User.count.should eq 2
    emails.count.should eq 2
    confirm_link = URI.extract(emails.first.body.to_s, :http).first
    uri = URI.parse(confirm_link)
    visit "#{uri.path}?#{uri.query}"
    fill_in "Password", with: "123123123"
    fill_in "Confirmation", with: "12312312"
    click_button "Activate"
    expect(current_path).to eq '/users/confirmation'

    fill_in "Password", with: "123123123"
    fill_in "Confirmation", with: "123123123"
    click_button "Activate"
    expect(current_path).to eq user_path(user)
  end

  it "handles a card declined", vcr: true, js: true do
    User.count.should eq 1
    visit market_path market
    find('.top-enroll-btn').click
    current_path.should eq '/orders/new/sample-market'

    submit_order_form(card_number: '4000000000000002')

    page.text.should include "Your card was declined"
    Order.count.should eq 0
  end
end

