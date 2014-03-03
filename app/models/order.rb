class Order < ActiveRecord::Base
  # == Imports ==============================================================
  serialize :parameters

  # == Slug =================================================================
  # == Constants ============================================================
  GATEWAY_PAYPAL = 1
  GATEWAY_AUTHORIZE_NET = 2
  GATEWAY_STRIPE = 3

  STATUS_CREATED = 1
  STATUS_SUCCESSFUL = 2
  STATUS_DECLINED = 3

  ORDER_STATUSES = {
    1 => 'created',
    2 => 'completed',
    3 => 'declined',
  }

  # == Attributes ===========================================================
  attr_accessor :time, :checksum, :card_number, :card_cvv, :cc

  # == Relationships ========================================================
  belongs_to :course
  belongs_to :subscription
  belongs_to :user
  belongs_to :market

  has_one :affiliate_sale

  # == Paperclip ============================================================
  # == Validations ==========================================================

  validates_presence_of :card_firstname
  validates_presence_of :card_lastname
  validates_presence_of :card_email

  # validate :validate_credit_card

  # == Scopes ===============================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================

  # Generate invoice based on *course_id* and *order_id*
  #
  # @param [Course] course the course to be used for the invoice
  # @param [Order] order the order to be used for the invoice
  # @return [String] the invoice string for orders
  def self.generate_invoice(course, affiliate_user = nil, affiliate_tracking = nil)
    invoice = "#{course.id}.#{rand(36**8).to_s(36)}"
    if affiliate_user
      invoice << ".#{affiliate_user.id}"
      invoice << ".#{affiliate_tracking.id}" if affiliate_tracking
    end
    invoice
  end

  def self.generate_workbook_invoice(order)
    invoice = "#{order.id}.#{rand(36**8).to_s(36)}"
    invoice
  end

  def self.generate_subscription_invoice(order)
    invoice = "#{order.id}.#{rand(36**8).to_s(36)}"
    invoice
  end

  # Parse the given invoice and populate an invoice hash
  #
  # @param [String] invoice the invoice returned by PayPal
  # @return [Hash] the hash contains the parsed data
  def self.parse_invoice(invoice)
    invoice_parts = invoice.split('.')
    parsed = {}
    parsed['affiliate_user_id'] = nil
    parsed['affiliate_tracking_id'] = nil
    parsed['course_id'] = invoice_parts[0].to_i if invoice_parts.length >= 1
    parsed['nonce'] = invoice_parts[1] if invoice_parts.length >= 2
    parsed['affiliate_user_id'] = invoice_parts[2].to_i if invoice_parts.length >= 3
    parsed['affiliate_tracking_id'] = invoice_parts[3].to_i if invoice_parts.length >= 4
    parsed
  end

  def self.create_order_by_market_and_user(market, user)
    order = Order.new
    order.market = market
    order.course = market.course
    order.user = user
    order.cost = market.course.cost
    order.card_firstname = user.firstname
    order.card_lastname = user.lastname
    order.card_email = user.email

    order.time = Time.now.to_i
    order.checksum = Digest::SHA1.hexdigest("#{order.market.id}#{order.market.id}#{order.time}#{Idealme::Application.config.secret_key_base.reverse}")
    order
  end

  def self.create_workbook_order_by_user(user)
    order = Order.new
    order.user = user
    order.cost = 700
    order.card_firstname = user.firstname
    order.card_lastname = user.lastname
    order.card_email = user.email

    order.time = Time.now.to_i
    order.checksum = Digest::SHA1.hexdigest("#{order.id}#{order.id}#{order.time}#{Idealme::Application.config.secret_key_base.reverse}")
    order
  end

  def self.create_subscription_order_by_user(user)
    order = Order.new
    order.user = user
    order.cost = 0
    order.card_firstname = user.firstname
    order.card_lastname = user.lastname
    order.card_email = user.email

    order.time = Time.now.to_i
    order.checksum = Digest::SHA1.hexdigest("#{order.id}#{order.id}#{order.time}#{Idealme::Application.config.secret_key_base.reverse}")
    order
  end

  # == Instance Methods =====================================================

  def complete!
    NewOrderNotification.perform_in(5.seconds, id)
    self.save!
    send_purchase_complete_mail
  end

  def send_purchase_complete_mail
    if course && course.roger_love?
      PurchaseMailer.roger_love(user).deliver
    elsif course?
      PurchaseMailer.confirmed(self).deliver
    elsif subscription?
      PurchaseMailer.subscribed(self).deliver
    elsif workbook?
      PurchaseMailer.workbook(self).deliver
    end
  end

  def valid_checksum?(validate_market_id, validate_course_id, validate_time)
    checksum == Digest::SHA1.hexdigest("#{validate_market_id}#{validate_course_id}#{validate_time}#{Idealme::Application.config.secret_key_base.reverse}")
  end

  def course?
    data.present? && data['order_type'] == "course"
  end

  def workbook?
    data.present? && data['order_type'] == "workbook"
  end

  def subscription?
    data.present? && data['order_type'] == "subscription"
  end
end
