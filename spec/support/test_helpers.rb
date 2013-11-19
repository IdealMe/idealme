module TestHelpers

  def buy_course_as(user, slug = 'my-link', market = nil)
    login_as(user, scope: :user, run_callbacks: false)

    if market
      visit "/now/#{slug}/#{market}"
    else
      visit "/now/#{slug}"
    end

    find('.enroll-btn').click
    fill_in "Card Number", with: '1234123412341234'
    fill_in "Security Code", with: '123'
    order_response = double(:success? => true)
    ActiveMerchant::Billing::StripeGateway.any_instance.stub(:purchase).and_return(order_response)
    Order.any_instance.stub(:valid?).and_return(true)
    click_button "Complete Purchase"
    logout(:user)
  end

  def screenshot
    if Capybara.current_driver == :poltergeist
      #Capybara::Screenshot.screen_shot_and_open_image

      count = Dir.glob('public/screenshots/test-*.png').length + 1
      outpath = "public/screenshots/test-#{"%02d" % count}.png"
      save_screenshot(outpath, full: true)
      # exec('open test.png')
      # x = `open -F public/test.png`
    else
      save_and_open_page
    end
  end

  def emails
    ActionMailer::Base.deliveries
  end

  def last_email
    ActionMailer::Base.deliveries.last
  end

end
