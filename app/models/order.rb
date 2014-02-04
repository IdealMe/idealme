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
    1 => "created",
    2 => "completed",
    3 => "declined",
  }

  # == Attributes ===========================================================
  attr_accessor :time, :checksum, :card_number, :card_cvv, :cc

  # == Relationships ========================================================
  belongs_to :course
  belongs_to :user
  belongs_to :market

  has_one :affiliate_sale

  # == Paperclip ============================================================
  # == Validations ==========================================================

  validates_presence_of :card_firstname
  validates_presence_of :card_lastname
  validates_presence_of :card_email

  validate :validate_credit_card

  # == Scopes ===============================================================
  # == Callbacks ============================================================
  before_validation :build_credit_card

  # == Class Methods ========================================================

  # Generate invoice based on *course_id* and *order_id*
  #
  # @param [Course] course the course to be used for the invoice
  # @param [Order] order the order to be used for the invoice
  # @return [String] the invoice string for orders
  def self.generate_invoice(course, affiliate_user=nil, affiliate_tracking=nil)
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

  # Parse the given invoice and populate an invoice hash
  #
  # @param [String] invoice the invoice returned by PayPal
  # @return [Hash] the hash contains the parsed data
  def self.parse_invoice(invoice)
    invoice_parts = invoice.split('.')
    parsed = Hash.new
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

  # == Instance Methods =====================================================

  def complete!
    NewOrderNotification.perform_in(5.seconds, self.id)
    self.save!
    self.send_course_purchase_complete_mail
  end

  def send_course_purchase_complete_mail
    if course && course.roger_love?
      PurchaseMailer.roger_love(user).deliver
    elsif course
      PurchaseMailer.confirmed(self).deliver
    else
      PurchaseMailer.workbook(self).deliver
    end
  end

  def build_credit_card
    unless gateway == GATEWAY_PAYPAL
      self.cc ||= ActiveMerchant::Billing::CreditCard.new(
          brand: self.card_type,
          number: self.card_number,
          verification_value: self.card_cvv,
          month: self.card_exp_month,
          year: self.card_exp_year,
          first_name: self.card_firstname,
          last_name: self.card_lastname
      )
      self.card_number_4 = self.card_number[-4, 4]
    end
  end

  def validate_credit_card
    unless gateway == GATEWAY_PAYPAL
      self.cc.valid?
      self.cc.errors.each do |error|
        next if error.last.length == 0
        field_name = error.first
        if field_name == 'year'
          mapped_field = :card_exp_year
        elsif field_name =='month'
          mapped_field = :card_exp_month
        elsif field_name =='number'
          mapped_field = :card_number
        elsif field_name =='verification_value'
          mapped_field = :card_cvv
        elsif field_name =='first_name'
          mapped_field = :card_firstname
        elsif field_name =='last_name'
          mapped_field = :card_lastname
        elsif field_name =='email'
          mapped_field = :card_email
        elsif field_name =='brand'
          mapped_field = :card_type
        else
          ap field_name
          raise 'Uncaught credit card errors'
        end

        if mapped_field
          field_errors = error.last
          field_errors.each do |error|
            errors.add(mapped_field, error)
          end
        end

      end
    end
  end


  def valid_checksum?(validate_market_id, validate_course_id, validate_time)
    self.checksum == Digest::SHA1.hexdigest("#{validate_market_id}#{validate_course_id}#{validate_time}#{Idealme::Application.config.secret_key_base.reverse}")
  end

end
