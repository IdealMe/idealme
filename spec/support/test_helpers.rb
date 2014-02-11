module TestHelpers

  def stripe_js_finished?
    ap page.html.include? "stripeFailed"
    page.has_css?("input[name='stripeToken']") || page.has_css?("input[name='stripeFailed']")
  end

  def wait_for_stripe
    Timeout.timeout(10.seconds) do
      loop until stripe_js_finished?
    end
    sleep 1
  end

  def submit_order_form(options = {})
    fill_in "Card Number", with: options.fetch(:card_number, '4242424242424242')
    fill_in "Security Code", with: '123'
    fill_in "First Name", with: "Bean"
    fill_in "Last Name", with: "Salad"
    fill_in "Email Address", with: options.fetch(:email, "beansalad@idealme.com")
    fill_in "Card exp month", with: '01'
    fill_in "Card exp year", with: '2020'
    click_button "Complete Purchase"

    sleep 2
    ap stripe_js_finished?


    #wait_for_stripe
  end

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

  def screenshot(preview = false)
    return if ENV['CI']
    if Capybara.current_driver == :poltergeist
      #Capybara::Screenshot.screen_shot_and_open_image

      count = Dir.glob('public/screenshots/test-*.png').length + 1
      outpath = "public/screenshots/test-#{"%02d" % count}.png"
      save_screenshot(outpath, full: true)
      # exec('open test.png')
      x = `open -F #{outpath}` if preview
    else
      save_and_open_page if preview
    end
  end

  def emails
    ActionMailer::Base.deliveries
  end

  def last_email
    ActionMailer::Base.deliveries.last
  end



end
