# Used for Paypal postbacks and Paypal instant payment notification.
#
# This is a very basic Paypal payment gateway
#
# This depends on ActiveMerchant from Spree with the custom Active Merchant's action view helper. Which basically allows encryption of POST data.
#
#
# -8.u0zwz2mo.298
# 802.6khqreo2.1
# 0.1.153.j5i2asi8
#
# If first unit is 0, this is a plan subscription
#   plan id : second unit
#   user id : third unit
#   nonce   : fourth unit
#
# If first unit is > 0, this is a course subscription, of logged in user
# If first unit is < 0, this is a course subscription, of new user
#
class Webhook::PaypalsController < ApplicationController
  include ActiveMerchant::Billing::Integrations
  protect_from_forgery except: [:paypal_create, :paypal_return]
  # Paypal will redirect the user here after successful payment
  def paypal_return
    session[:paypal_ipn] = true
    redirect_to(new_user_session_path)
  end

  # Paypal will redirect the user here when the user clicks cancel and return to site
  def paypal_cancel
    redirect_to(root_path)
  end

  def do_subscr_signup(notify, post)
    invoice = notify.invoice.split(".")
    control_code = invoice[0].to_i
    if control_code < 0 # New user for courses
      course_id = notify.item_id.to_i
      course = Course.where(id: course_id).first
      email = post[:payer_email]
      user = User.where(email: email).first

      unless user
        password = rand(36**8).to_s(36)
        user = User.create!(email: email, username: User.generate_unique_username(post[:first_name]), firstname: post[:first_name], lastname: post[:last_name], password: password, password_confirmation: password)
        DeviseMailer.auto_registration_instructions(user, password)
      end
      user.subscribe_course(course)
      order = Order.create_complete_order(course, user, notify.transaction_id, notify.status, post.to_json, IM_ORDER_PAID, post[:subscr_id])
      if invoice.length > 2
        affiliate_user = invoice[2].to_i
        affiliate_tracking = nil
        affiliate_tracking = invoice[3].to_i if invoice.length == 4
        AffiliateSale.create_complete_affiliate_sale_raw(order, affiliate_user, affiliate_tracking)
      end
    elsif control_code > 0 # Existing user for course
      order = Order.where(id: control_code).first
      course = Course.where(id: order.course_id).first
      user = order.user
      user.subscribe_course(course)
      order.complete_order(notify.transaction_id, notify.status, post.to_json, IM_ORDER_PAID, post[:subscr_id])
      if invoice.length > 2
        affiliate_user = invoice[2].to_i
        affiliate_tracking = nil
        affiliate_tracking = invoice[3].to_i if invoice.length == 4
        AffiliateSale.create_complete_affiliate_sale_raw(order, affiliate_user, affiliate_tracking)
      end
    elsif control_code == 0 # Existing user for plan
      plan_id = invoice[1]
      user_id = invoice[2]
      user = User.where(id: user_id).first
      plan = Plan.where(id: plan_id).first
      #TODO Fix this shit
      if user && plan
        user.subscribe_plan(plan)
        Service.create_complete_service(plan, user, notify.transaction_id, notify.status, post.to_json, IM_ORDER_PAID, post[:subscr_id])
      end

    end
  end

  def do_subscr_payment(notify, post)
    invoice = notify.invoice.split(".")
    control_code = invoice[0].to_i
    if control_code == 0
      SubscriptionService.create!(subscriber_id: post[:subscr_id], transaction_type: notify.type, transaction_id: notify.transaction_id, transaction_status: notify.status, ipn: post.to_json, payment_date: DateTime.strptime(post['payment_date'], "%H:%M:%S %b %d, %Y %z"), status: IM_ORDER_PAID)
    else
      SubscriptionOrder.create!(subscriber_id: post[:subscr_id], transaction_type: notify.type, transaction_id: notify.transaction_id, transaction_status: notify.status, ipn: post.to_json, payment_date: DateTime.strptime(post['payment_date'], "%H:%M:%S %b %d, %Y %z"), status: IM_ORDER_PAID)
    end
  end

  def do_web_accept(notify, post)
    invoice = Order.parse_invoice(notify.invoice)

    if invoice['order_id'] < 0 # for new user
      course_id = invoice['course_id']
      course = Course.where(id: course_id).first
      email = post[:payer_email]
      user = User.where(email: email).first
      unless user
        password = rand(36**8).to_s(36)
        user = User.create!(email: email, username: User.generate_unique_username(post[:first_name], post[:last_name]), firstname: post[:first_name], lastname: post[:last_name], password: password, password_confirmation: password)
        DeviseMailer.auto_registration_instructions(user, password)
      end
      user.subscribe_course(course)
      order = Order.create_complete_order(course, user, notify.transaction_id, notify.status, post.to_json, IM_ORDER_PAID)
      AffiliateSale.create_complete_affiliate_sale_raw(order, invoice['affiliate_user_id'], invoice['affiliate_tracking_id'])
    elsif invoice['order_id'] > 0
      order = Order.where(id: invoice['order_id']).includes(:user, :course).first
      order.user.subscribe_course(order.course)
      order.complete_order(notify.transaction_id, notify.status, post.to_json, IM_ORDER_PAID)
      AffiliateSale.create_complete_affiliate_sale_raw(order, invoice['affiliate_user_id'], invoice['affiliate_tracking_id'])
    end
  end

  # Paypal will POST to this for IPN.
  # TODO: Make sure nothing breaks when pushing from staging to production
  def paypal_create
    notify = Paypal::Notification.new(request.raw_post)
    paypal_ipn_log ||= Logger.new("#{Rails.root}/log/paypal_ipn.log")
    paypal_ipn_log.info(params)
    if notify.acknowledge
      ActiveRecord::Base.transaction do
        begin
          print notify.type.to_yaml
          if notify.type == 'subscr_signup'
            do_subscr_signup(notify, params)
          elsif notify.type == 'subscr_payment'
            do_subscr_payment(notify, params)
          elsif notify.type == 'web_accept'
            do_web_accept(notify, params)
          end
        rescue => e
        ensure
        end
      end
    end
    render nothing: true
  end
end
