class Dashboard::AffiliatesController < Dashboard::ApplicationController
  before_filter :authenticate
  # List the affiliate link, this is the affiliate dashboard
  def index
    @tab = params[:tab]
    @tab = cookies.signed[:affilite_last_tab] if @tab.nil?
    @tab = 'stats' if @tab.nil?
    cookies.signed[:affilite_last_tab] = @tab
    @base = params.except(:controller, :action, :filter)
    case @tab
      when 'stats'
        @affiliate_clicks = ::AffiliateClick.where('affiliate_clicks.user_id = ?', current_user.id)
          .where('date(affiliate_clicks.created_at) >= ? AND date(affiliate_clicks.created_at) <= ?', @from_date, @to_date)
          .references(:affiliate_clicks)
        @affiliate_sales = ::AffiliateSale.where('affiliate_sales.user_id = ?', current_user.id)
          .where('date(orders.created_at) >= ? AND date(orders.created_at) <= ?', @from_date, @to_date)
          .includes({:order => :course})
          .references(:orders, :affiliate_sales)
        @sum_unique_click = 0
        @sum_total_click = 0
        @affiliate_clicks.each do |affiliate_click|
          @sum_unique_click += 1
          @sum_total_click += affiliate_click.clicks
        end
        @sum_commission = 0
        @affiliate_sales.each do |affiliate_sales_completed|
          order = affiliate_sales_completed.order
          @sum_commission += (order.cost * (order.course.affiliate_commission/100.0)) if order.status == Order::STATUS_SUCCESSFUL
        end
        @conversion = (@affiliate_sales.length * 1.00)/(@sum_unique_click*1.00) * 100.00
        @conversion = 0 if @conversion.nan?
      when 'links'
        @affiliate_links = ::AffiliateLink.where('affiliate_links.user_id = ?', current_user.id).includes(:sales => {:order => :course})

        ::AffiliateLink.class_eval do
          attr_accessor :sales_list #affiliate_sales is taken
          attr_accessor :sum_gross
          attr_accessor :sum_commission
          attr_accessor :unique_click
        end
        @affiliate_links.each do |affiliate_link|
          affiliate_link.sales_list = affiliate_link.sales
          affiliate_link.unique_click = 0
          affiliate_link.affiliate_clicks.each { |affiliate_click| affiliate_link.unique_click += 1 }
          affiliate_link.sum_commission = 0
          affiliate_link.sum_gross = 0
          affiliate_link.sales_list.each do |sale|
            order = sale.order
            if order.status == Order::STATUS_SUCCESSFUL
              gross = order.cost
              affiliate_link.sum_gross += gross
              affiliate_link.sum_commission += (gross * (order.course.affiliate_commission/100.0))
            end
          end
        end
      when 'sale'
        @affiliate_sales = ::AffiliateSale.where('affiliate_sales.user_id = ?', current_user.id)
          .where('date(orders.created_at) >= ? AND date(orders.created_at) <= ?', @from_date, @to_date)
          .includes(:affiliate_link, {:order => [:course, :user]})
          .references(:orders)
          .references(:affiliate_sales)
        @sum_commission = 0
        ::AffiliateSale.class_eval do
          attr_accessor :gross
          attr_accessor :commission
          attr_accessor :course_commission_percent
        end
        @affiliate_sales.each do |affiliate_sale|
          affiliate_sale.gross = affiliate_sale.order.cost
          affiliate_sale.course_commission_percent = affiliate_sale.order.course.affiliate_commission
          affiliate_sale.commission = affiliate_sale.gross * (affiliate_sale.order.course.affiliate_commission/100.0)
          @sum_commission += affiliate_sale.commission if affiliate_sale.order.status == Order::STATUS_SUCCESSFUL
        end
      when 'urls'
        @courses = ::Course.includes(:default_market)
    end
  end

  def show
    @affiliate_link = ::AffiliateLink.where('affiliate_links.slug = ?', params[:id]).first
    @other_markets = Market.where("affiliate_tag != ?", @affiliate_link.market_tag)
    raise('That affiliate link does not exist') if @affiliate_link.nil?

    authorize!(:read, @affiliate_link)
    @affiliate_clicks = ::AffiliateClick.where('affiliate_links.slug = ?', params[:id])
      .where('date(affiliate_clicks.created_at) >= ? AND date(affiliate_clicks.created_at) <= ?', @from_date, @to_date)
      .includes(:affiliate_link)
      .references(:affiliate_links)

    @affiliate_sales = ::AffiliateSale.where('affiliate_links.slug = ?', params[:id])
      .where('date(orders.created_at) >= ? AND date(orders.created_at) <= ? AND affiliate_sales.completed = ?', @from_date, @to_date, true)
      .includes(:affiliate_link, {:order => [:course, :user]})
      .references(:affiliate_links, :orders)

    @unique_users = @affiliate_sales.map(&:order).flatten.map(&:user).uniq
    @unique_users_in_range = @unique_users.keep_if { |i| i.created_at >= @from_date.beginning_of_day && i.created_at <= @to_date.end_of_day }
    @unique_click = 0
    @total_click = 0
    @affiliate_clicks.each do |affiliate_click|
      @unique_click += 1
      @total_click += affiliate_click.clicks
    end
    @courses = ::Course.includes(:default_market)
    ::AffiliateSale.class_eval do
      attr_accessor :gross
      attr_accessor :commission
      attr_accessor :course_commission_percent
    end
    @sum_commission = 0
    @affiliate_sales.each do |affiliate_sale|
      order = affiliate_sale.order
      affiliate_sale.gross = order.cost
      affiliate_sale.course_commission_percent = order.course.affiliate_commission
      affiliate_sale.commission = affiliate_sale.gross * (affiliate_sale.course_commission_percent/100.0)
      @sum_commission += affiliate_sale.commission if order.status == Order::STATUS_SUCCESSFUL
    end
  end

  def new
    @affiliate_link = ::AffiliateLink.new
  end

  def edit
    @affiliate_link = ::AffiliateLink.find_by_slug(params[:id])
    raise(IdealMeException::RecordNotFound, 'That affiliate link does not exist') if @affiliate_link.nil?
  end

  def create
    @affiliate_link = ::AffiliateLink.new(affiliate_link_params)
    if @affiliate_link.save
      redirect_to dashboard_affiliate_path(@affiliate_link.slug), notice: 'Affiliate link was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @affiliate_link = ::AffiliateLink.find_by_slug(params[:id])
    if @affiliate_link.nil?
      raise(IdealMeException::RecordNotFound, 'That affiliate link does not exist')
    end
    if @affiliate_link.update_attributes(params[:affiliate_link])
      redirect_to dashboard_affiliate_path(@affiliate_link), notice: 'Affiliate link was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @affiliate_link = ::AffiliateLink.find_by_slug(params[:id])
    if @affiliate_link.nil?
      raise(IdealMeException::RecordNotFound, 'That affiliate link does not exist')
    end
    @affiliate_link.destroy
    redirect_to dashboard_affiliates_url
  end

  private
  def authenticate
    authorize!(:access, :affiliate)
  end

  def affiliate_link_params
    params.require(:affiliate_link).permit!
  end
end
