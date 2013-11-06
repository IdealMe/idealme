module MarketHelper

  def course_path(course)
    if Rails.env.development?
      market_path(course.default_market)
    else
      super
    end
  end

end