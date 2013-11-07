class Dashboard::CoursesController < Dashboard::ApplicationController
  before_filter :authenticate

  def index
    @tab = params[:tab]
    @tab = cookies.signed[:course_last_tab] if @tab.nil?
    @tab = 'stats' if @tab.nil?
    cookies.signed[:course_last_tab] = @tab
    @base = params.except(:controller, :action, :filter)
    case @tab
      when 'stats'
        @orders = ::Order.includes(:course, :affiliate_sale).where('orders.status != ?', IM_ORDER_CREATED).where('orders.created_at >= ? AND orders.created_at <= ?', @from_date, @to_date).where(:course_id => ::Course.where(:owner_id => current_user.id)).all
        @sum_sales_count = 0
        @sum_gross = 0
        @sum_fee = 0
        @sum_affiliate_fee = 0
        @orders.each do |order|
          if order.status == IM_ORDER_PAID
            @sum_sales_count += 1
            @sum_gross += order.cost
            @sum_fee += ((order.cost * order.course.affiliate_commission / 100) * IM_BUSINESS_SALE_HOUSE_PERCENT_TAKE_F + IM_BUSINESS_SALE_HOUSE_BASE_TAKE)
            @sum_affiliate_fee += (order.cost * (order.course.affiliate_commission / 100)) if order.affiliate_sale
          end
        end
      when 'course'
        @courses = ::Course.where(:owner_id => current_user.id).includes(:users)
      when 'affiliate'
        @affiliate = Hash.new
        @orders = ::Order.includes(:course, {:affiliate_sale => :user}).where('courses.owner_id = ? AND orders.status != ?', current_user.id, IM_ORDER_CREATED).where('orders.created_at >= ? AND orders.created_at <= ?', @from_date, @to_date).all
        @orders.each do |order|
          if (order.status == IM_ORDER_REFUND || order.status == IM_ORDER_PAID) && !order.affiliate_sale.nil?
            affiliate_user = order.affiliate_sale.user
            sum_affiliate = nil
            if @affiliate.has_key?(affiliate_user)
              sum_affiliate = @affiliate[affiliate_user]
            else
              sum_affiliate = Hash.new
              sum_affiliate[:orders_length] = 0
              sum_affiliate[:refunds_length] = 0
              sum_affiliate[:sum_gross] = 0
              sum_affiliate[:sum_fee] = 0
              sum_affiliate[:sum_subtotal] = 0
              sum_affiliate[:sum_affiliate_fee] = 0
              @affiliate[affiliate_user] = sum_affiliate
            end
            if order.status == IM_ORDER_PAID
              sum_affiliate[:orders_length] += 1
              sum_affiliate[:sum_gross] += order.cost
              sum_affiliate[:sum_fee] += order.cost * (order.course.affiliate_commission / 100) * IM_BUSINESS_SALE_HOUSE_PERCENT_TAKE_F + IM_BUSINESS_SALE_HOUSE_BASE_TAKE
              sum_affiliate[:sum_affiliate_fee] += (order.cost * (order.course.affiliate_commission / 100))
            else
              sum_affiliate[:refunds_length] += 1
            end

            @affiliate[affiliate_user] = sum_affiliate
          end
        end
      when 'sale'
        @orders = ::Order.includes(:course, :user, {:affiliate_sale => :user}).where('courses.owner_id = ? AND orders.status != ?', current_user.id, IM_ORDER_CREATED).where('orders.created_at >= ? AND orders.created_at <= ?', @from_date, @to_date).all
        ::Order.class_eval do
          attr_accessor :gross
          attr_accessor :fee
          attr_accessor :affiliate_fee
        end
        @orders.each do |order|
          order.gross = order.cost
          order.fee = (order.cost * (order.course.affiliate_commission / 100)) * IM_BUSINESS_SALE_HOUSE_PERCENT_TAKE_F + IM_BUSINESS_SALE_HOUSE_BASE_TAKE
          if order.affiliate_sale.nil?
            order.affiliate_fee = 0
          else
            order.affiliate_fee = order.gross * (order.course.affiliate_commission / 100)
          end
        end
      when 'student'
        @users = User.where(:id => ::CourseUser.where(:course_id => ::Course.where(:owner_id => current_user.id).where('orders.created_at >= ? AND orders.created_at <= ?', @from_date, @to_date).joins(:orders))).all
    end
  end

  def add_student
    course = ::Course.where(:id => params[:course_id]).first
    redirect_to(dashboard_courses_path) and return if course.nil?
    user = ::User.where('email = ? OR username = ?', params[:login], params[:login]).first
    redirect_to(dashboard_course_path(course, :tab => 'student')) and return if user.nil? || params[:login].nil? || params[:login].length == 0
    course.add_student(user)
    redirect_to(dashboard_course_path(course, :tab => 'student'))
  end

  def show
    @tab = params[:tab]
    @tab = cookies.signed[:dashboard_course_show_last_tab] if @tab.nil?
    @tab = 'student' if @tab.nil? || !['sale', 'export_email', 'student'].include?(@tab)
    cookies.signed[:dashboard_course_show_last_tab] = @tab
    @base = params.except(:controller, :action, :filter)
    @course = ::Course.where('slug = ?', params[:id]).includes(:users).first
    raise(IdealMeException::RecordNotFound, 'That course does not exist') if @course.nil?

    # Authorize the request
    authorize!(:read_extended, @course)
    case @tab
      when 'sale'
        @orders = ::Order.where('course_id = ? AND status != ?', @course.id, IM_ORDER_CREATED).includes(:course, :user, {:affiliate_sale => :user}).all
        ::Order.class_eval do
          attr_accessor :gross
          attr_accessor :fee
          attr_accessor :affiliate_fee
        end
        @orders.each do |order|
          order.gross = order.cost
          order.fee = (order.gross) * (@course.affiliate_commission / 100) * IM_BUSINESS_SALE_HOUSE_PERCENT_TAKE_F + IM_BUSINESS_SALE_HOUSE_BASE_TAKE
          if order.affiliate_sale.nil?
            order.affiliate_fee = 0
          else
            order.affiliate_fee = (order.gross) * (@course.affiliate_commission / 100)
          end
        end
      when 'export_email'
      when 'student'
    end
  end

  private
  def authenticate
    authorize!(:access, :course_creation)
  end

end
