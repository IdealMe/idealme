module ApplicationHelper
  def render_activity(activity)
    render_key = "activities/#{activity.action.downcase.gsub('.', '/')}"
    render :partial => render_key, :locals => {:activity => activity}
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
  def get_friendly_affiliate_tracking
    friendly = nil
    zid = cookies.signed[:zid]
    if zid
      last_affiliate_user = User.get_affiliate_user(zid).first
      friendly = "#{last_affiliate_user.username}" if last_affiliate_user
      tid = cookies.signed[:tid]
      if tid
        last_affiliate_tracking = AffiliateTracking.where(:affiliate_tag => tid).first
        friendly = "#{friendly}/#{last_affiliate_tracking.name}" if last_affiliate_tracking
      end
    end
    friendly
  end


  def month_options_for_select(selected_value = nil)
    months = (1..12).map { |h| ["%02d"%h, h] }
    options_for_select(months, selected_value)
  end
end
