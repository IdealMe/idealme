module ApplicationHelper
  def render_activity(activity)
    render_key = "activities/#{activity.action.downcase.gsub('.', '/')}"
    render partial: render_key, locals: {activity: activity}
  end

  # A wrapper for number_to_currency which converts pennies to currency
  #
  # @param [Integer] amount The amount in pennies to be converted to currency
  # @param [Hash] option Setting the precision and locale
  #  :precision: Sets the precision of the conversion, defaults to *2*
  #  :locale: Sets the locale of the conversion, defaults to *:en_us*
  # @return [Float] The formatted cost
  def penny_to_currency(amount, option = {})
    option[:precision] = 2 unless option.has_key?(:precision)
    option[:locale] = :en_us unless option.has_key?(:locale)
    amount = amount/100.00
    number_to_currency(amount, option)
  end

  def body_class
    # Need this version for older pages
    classes = ["#{params[:controller].gsub('/', '-')}-#{params[:action]}"]
    classes << (user_signed_in? ? 'logged-in' : 'logged-out')
    classes << 'admin' if params[:controller].include?('admin/')
    classes << 'dashboard' if params[:controller].include?('dashboard/')
    classes.join(" ")
  end


  # Returns active or inactive class for tabs
  #
  # @param [String,Array] expect The expected value
  # @param [String] target The target value
  # @param [String] active_text The active class
  # @param [String] inactive_text The inactive class
  # @return [String] The class of the current tabs
  def active_tab?(expect, target, active_text='active', inactive_text='inactive')
    if expect.kind_of?(Array) && expect.include?(target)
      active_text
    elsif expect.kind_of?(String) && expect == target
      active_text
    else
      inactive_text
    end
  end

  # Get the human readable version of the affiliate user and the affiliate campaign that is cookied on the customer's computer
  #
  # This is displayed in the footer
  #
  # @return [String] The friendly cookie string
  def get_friendly_affiliate_link
    friendly = nil
    zid = cookies.signed[:zid]
    if zid
      last_affiliate_user = User.get_affiliate_user(zid).first
      friendly = "#{last_affiliate_user.username}" if last_affiliate_user
      tid = cookies.signed[:tid]
      if tid
        last_affiliate_link = AffiliateLink.where(slug: tid).first
        friendly = "#{friendly}/#{last_affiliate_link.slug}" if last_affiliate_link
      end
    end
    friendly
  end


  def cc_month_options_for_select(selected_value = nil)
    months = (1..12).map { |h| ["%02d"%h, h] }
    # options_for_select(months, selected_value)
    months
  end

  def cc_year_options_for_select(selected_value = nil)
    years = (Time.now.year..Time.now.year+10).map { |h| ["%02d"%h, h] }
    # options_for_select(years, selected_value)
    years
  end

  def environment_info
    if Rails.env.development? || Rails.env.test? || Rails.env.staging?
      content_tag :div, class: 'environment-info' do
        Rails.env
      end
    end
  end

  def guessed_media_type(file_name)
    guess = IM_PAYLOAD_DOCUMENT if file_name.include?('.pdf')
    guess = IM_PAYLOAD_ARCHIVE if file_name.include?('.zip')
    guess = IM_PAYLOAD_VIDEO if file_name.include?('.mov')
    guess = IM_PAYLOAD_VIDEO if file_name.include?('.mp4')
    guess = IM_PAYLOAD_VIDEO if file_name.include?('.flv')
    guess = IM_PAYLOAD_AUDIO if file_name.include?('.mp3')
    guess
  end

  def image_or_video_tag(path)
    render(partial: "partials/market_promo_media", locals: { url: path, media_type: guessed_media_type(path) })
  end
end
