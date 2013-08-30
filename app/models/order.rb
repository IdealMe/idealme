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

  # == Attributes ===========================================================
  attr_accessible :user_id, :market_id, :course_id, :card_firstname, :card_lastname, :card_type, :card_exp_month,
                  :card_exp_year, :billing_address1, :billing_address2, :billing_city, :billing_zip, :billing_state, :billing_country, :parameters


  attr_accessor :time, :checksum, :card_number, :card_cvv, :cc
  attr_accessible :time, :checksum, :card_number, :card_cvv, :cc


  # == Relationships ========================================================
  belongs_to :course
  belongs_to :user
  belongs_to :market

  has_many :affiliate_sales

  # == Paperclip ============================================================
  # == Validations ==========================================================

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
    order.checksum = Digest::SHA1.hexdigest("#{order.market.id}#{order.market.id}#{order.time}#{Idealme::Application.config.secret_token.reverse}")

    order
  end

  # == Instance Methods =====================================================

  def purchase


  end

  def build_credit_card
    self.cc ||= ActiveMerchant::Billing::CreditCard.new(
        :brand => self.card_type,
        :number => self.card_number,
        :verification_value => self.card_cvv,
        :month => self.card_exp_month,
        :year => self.card_exp_year,
        :first_name => self.card_firstname,
        :last_name => self.card_lastname
    )
    self.card_number_4 = self.card_number[-4, 4]
  end

  def validate_credit_card
    self.cc.valid?

    self.cc.errors.each do |error|
      next if error.last.length == 0
      field_name = error.first
      if field_name == 'year'
        mapped_field = :card_exp_year
      elsif field_name =='number'
        mapped_field = :card_number
      else
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


  def valid_checksum?(validate_market_id, validate_course_id, validate_time)
    self.checksum == Digest::SHA1.hexdigest("#{validate_market_id}#{validate_course_id}#{validate_time}#{Idealme::Application.config.secret_token.reverse}")
  end

end
