class OrdersController < ApplicationController
  before_filter :require_authentication
  before_filter :load_active_merchant_validator_with_market, :only => [:new]
  before_filter :build_active_merchant_validator_with_market, :only => [:create]
  before_filter :ensure_product_user_uniqueness

  # GET /orders
  def index
    redirect_to markets_path and return
  end

  # GET /orders/new
  def new
  end

  # POST /orders
  def create
    market_id = @active_merchant_validator.market_id
    course_id = @active_merchant_validator.course_id
    time = @active_merchant_validator.time

    redirect_to(markets_path) and return unless @active_merchant_validator.valid_checksum?(market_id, course_id, time)
    @active_merchant_validator.valid?
    if @active_merchant_validator.valid? && @active_merchant_validator.cc.valid?
      gateway = AUTHORIZED_NET_GATEWAY
      gateway_options = {}
      if gateway.is_a?(ActiveMerchant::Billing::AuthorizeNetGateway)
        #gateway_options[:order_id] = Order.generate_invoice(@course.id)
        gateway_options[:description] = @market.course.name
        gateway_options[:email] = @active_merchant_validator.email
        gateway_options[:customer] = current_user.id
      end

      @response = gateway.purchase(@market.course.cost, @active_merchant_validator.cc, gateway_options)
      if @response.success?
        #TODO: Order
        #TODO: Affiliate
        current_user.subscribe_course(@market.course)
        render :create
      else
        flash[:alert] = @response.message
        render :new
      end
    else
      flash[:alert] = 'There was a problem validating your information. Please ensure all your information are correct'
      render :new
    end
  end

  protected
  def load_active_merchant_validator_with_market
    @market = Market.find(params[:id])
    @active_merchant_validator = ActiveMerchantValidator.new({:market => @market})
  rescue ActiveRecord::RecordInvalid
    redirect_to markets_path and return
  end

  def build_active_merchant_validator_with_market
    @active_merchant_validator = ActiveMerchantValidator.new(params[:active_merchant_validator])
    @market = Market.where(:id => @active_merchant_validator.market_id).first
    raise ActiveRecord::RecordInvalid unless @market
  rescue ActiveRecord::RecordInvalid
    redirect_to markets_path and return
  end

  def ensure_product_user_uniqueness
    if current_user
      market = Market.where(:id => @active_merchant_validator.market_id).includes(:course).first
      raise(IdealMeException::RecordNotFound, 'That market does not exist') unless market
      course_user = CourseUser.where(:course_id => market.course.id, :user_id => current_user.id).first
      redirect_to(course_path(market.course)) and return if course_user
    end
  end
end

