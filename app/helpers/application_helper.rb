module ApplicationHelper

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
    classes = ["#{params[:controller]}_#{params[:action]}"]
    classes << params[:controller] << params[:action]
    classes << (user_signed_in? ? 'logged_in' : 'logged_out')
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
end
