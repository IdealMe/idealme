class ActiveMerchantValidator
  include ActiveModel::Conversion
  include ActiveModel::Serialization
  extend ActiveModel::Naming
  extend ActiveModel::Callbacks
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks

  attr_accessor :gateway
  attr_accessor :market, :market_id, :course_id, :time, :checksum
  attr_accessor :firstname, :lastname, :email
  attr_accessor :card_number, :card_exp, :card_type, :cvv
  attr_accessor :cc
  attr_accessor :billing_address1, :billing_address2, :billing_company, :billing_phone, :billing_zip, :billing_city, :billing_country, :billing_state


  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
    if @market.is_a?(Market)
      @course_id = market.course.id
      @market_id = market.id
      @time = Time.now.to_i
      @checksum = Digest::SHA1.hexdigest("#{@market_id}#{@course_id}#{@time}#{Idealme::Application.config.secret_token.reverse}")
    end
  end


  def valid_checksum?(validate_market_id, validate_course_id, validate_time)
    @checksum == Digest::SHA1.hexdigest("#{validate_market_id}#{validate_course_id}#{validate_time}#{Idealme::Application.config.secret_token.reverse}")
  end

  before_validation :before_validation
  validates_length_of :card_exp, :is => 4
  validates_presence_of :market_id, :course_id, :time, :checksum, :firstname, :lastname, :card_number, :card_exp, :cvv
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i


  def gateway=(g)
    self.gateway = g
  end

  def gateway
    self.gateway
  end

  def before_validation
    self.cc ||= ActiveMerchant::Billing::CreditCard.new(
        :brand => self.card_type,
        :number => self.card_number,
        :verification_value => self.cvv,
        :month => self.get_month,
        :year => self.get_year,
        :first_name => self.firstname,
        :last_name => self.lastname
    )
    self.cc.valid?
    self.cc.errors.each do |key, message|
      if key == 'month' && message.length > 0
        self.errors.add(:card_exp, message)
      end
      if key == 'year' && message.length > 0
        self.errors.add(:card_exp, message)
      end
      if key == 'verification_value' && message.length > 0
        self.errors.add(:cvv, message)
      end
      if key == 'number' && message.length > 0
        self.errors.add(:card_number, message)
      end
    end
  end

  def get_month
    card_exp[0..1].to_i if card_exp
  end

  def get_year
    ('20' + card_exp[2..3]).to_i if card_exp[2..3]
  end


  def persisted?
    false
  end
end