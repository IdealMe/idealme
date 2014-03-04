module TestHelpers

  def delete_vcr_cassette
    file = VCR.current_cassette.file
    File.delete(file) if File.exist?(file)
    VCR.eject_cassette
  end

  def fill_in_order_form(options = {})
    expect(page.text).to include "First Name"
    fill_in "First Name", with: options.fetch(:firstname, "Bean")
    fill_in "Last Name", with: options.fetch(:lastname, "Salad")
    fill_in "Email Address", with: options.fetch(:email, "beansalad@idealme.com")

    fill_in "Card Number", with: options.fetch(:card_number, '4242424242424242')
    fill_in "Security Code", with: options.fetch(:card_cvv, '123')
    fill_in "Card exp month", with: options.fetch(:card_exp_month, '01')
    fill_in "Card exp year", with: options.fetch(:card_exp_year, '2020')
  end

  class MockSubscriptions
    include Enumerable
    def initialize
      @subs = []
    end

    def []
      @subs
    end

    def create(args)
      obj = OpenStruct.new
      obj.id = SecureRandom.hex
      obj.plan = args
      @subs.push obj
      obj
    end

    def count
      @subs.length
    end

    def each
      @subs.each do |sub|
        yield sub
      end
    end
  end

  def submit_order_form(options = {})
    subscriptions = MockSubscriptions.new
    subscriptions.stub(:[]).and_return([{id: "subscription-id-123"}])
    customer = double(:customer, id: "stripe-customer-id-123", subscriptions: subscriptions)

    Stripe::Customer.stub(:create) do |args|
      customer.subscriptions.create({plan: args[:plan]}) if args[:plan]
      customer
    end
    Stripe::Customer.stub(:retrieve).and_return(customer)

    charge = double(:charge)
    Stripe::Charge.stub(:create) do |args|
      if options[:card_number].try(:include?, "4000")
        raise Stripe::CardError.new('Your card was declined','param','code')
      else
        charge
      end
    end

    #page.evaluate_script('window.IM_USE_STRIPE = true;') if options[:use_stripe]
    page.evaluate_script('$(".alert").remove()')
    expect(page.text).to_not include 'card was declined'

    card_email = options.fetch(:email, "beansalad@idealme.com")
    fill_in_order_form(options)
    click_button "Complete Purchase"
    Timeout.timeout(15.seconds) do
      completed = false
      while completed == false
        order = Order.order("created_at ASC").last
        if order && order.reload.card_email == card_email
          completed = true
        end

        if page.text.include? 'card was declined'
          completed = true
        end

        if current_path == '/login'
          completed = true
        end

        sleep 1
      end
    end

    order = Order.where(card_email: card_email).order("created_at ASC").last
    order
  rescue Timeout::Error => e
    ap "submit order form timeout error"
    screenshot true
  end

  def buy_course_as(user, slug = 'my-link', market = nil)
    login_as(user, scope: :user, run_callbacks: false)

    if market
      visit "/now/#{slug}/#{market}"
    else
      visit "/now/#{slug}"
    end
    expect(page).to have_css(".enroll-btn")
    find('.enroll-btn').click
    submit_order_form({
      card_number: '4242424242424242',
      email: user.email,
      first_name: user.firstname,
      last_name: user.lastname,
    })

    logout(:user)
    sleep 1
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
