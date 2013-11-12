module TestHelpers

  def screenshot
    if Capybara.current_driver == :poltergeist
      #Capybara::Screenshot.screen_shot_and_open_image
      save_screenshot('public/test.png', full: true)
      # exec('open test.png')
      x = `open -F public/test.png`
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
