# Helpers for displaying payments
#
# @see Payment
module Dashboard::PaymentsHelper
  include Carmen

  # Formats a given payment with proper HTML
  #
  # @param [Payment] payment A payment object to be formatted
  # @return [String] The formatted payment object
  def payment_format_address(payment)
    address = ''
    return address.html_safe if payment.nil?
    address << "<address><strong>#{payment.firstname} #{payment.lastname}</strong><br />"
    address << "#{payment.unit} - " if payment.unit && payment.unit.length > 0
    address << "#{payment.address1}<br />"
    address << "#{payment.address2}<br />" if payment.address2 && payment.address2.length > 0
    address << "#{payment.city}, #{payment.province}, #{Carmen::Country.coded(payment.country).name}<br />#{payment.postal_code}</address>"
    return address.html_safe
  end
end
