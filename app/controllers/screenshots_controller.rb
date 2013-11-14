class ScreenshotsController < ApplicationController
  layout false
  def index
    return unless Rails.env.test? || Rails.env.development?

    @screenshots = Dir.glob('public/screenshots/test-*.png').map{|path| path.sub(/^public/,'') }
    ap @screenshots
  end

  def reset
    return unless Rails.env.test? || Rails.env.development?
    `rm public/screenshots/test-*.png`
    redirect_to '/screenshots/index'
  end
end
