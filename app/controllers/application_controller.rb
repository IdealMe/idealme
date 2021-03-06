class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_gon
  before_filter :set_meta
  before_filter :set_time_zone
  # before_filter :set_common_date
  before_filter :authenticate_staging
  before_filter :set_last_location
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :set_conversion_partial

  around_filter :record_request
  # https://github.com/plataformatec/devise/wiki/How-To:-Redirect-back-to-current-page-after-sign-in,-sign-out,-sign-up,-update

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.debug("CanCan: Access denied on #{exception.action} #{exception.subject.inspect}")
    if exception.subject.is_a?(Course) && exception.action == :read
      if exception.subject.default_market
        redirect_to(market_path(exception.subject.default_market))
      else
        redirect_to(markets_path)
      end
      # elsif exception.subject.is_a?(Article) && exception.action == :read
      #  if exception.subject.default_market
      #    redirect_to(market_path(exception.subject.default_market))
      #  else
      #    redirect_to(markets_path)
      #  end
    else
      redirect_to new_user_session_path, alert: exception.message
    end
  end

  def record_request
    cookies[:imsid] ||= SecureRandom.urlsafe_base64(30)
    bm = Benchmark.measure {
      yield
    }
    return if request.fullpath =~ /^\/(__ping|webhook)/
    request_record = RequestRecord.new
    request_record.user_id = current_user.id if current_user
    request_record.fullpath = request.fullpath
    request_record.session_id = cookies[:imsid]
    request_record.conversion = @conversion
    request_record.request_duration = bm.real
    request_record.request_method = request.request_method
    request_record.save!
  end

  # Get the current affiliate user that is cookied on the customer's computer
  # @return [User] If the affiliate user that is cookied on the customer's computer
  # @return [nil] Otherwise
  def get_affiliate_user
    user = User.where(affiliate_tag: cookies.signed[:zid]).first if cookies.signed[:zid]
    if user && user.access_affiliate
      user
    else
      cookies.delete :zid
      nil
    end
  end

  # Get the current affiliate user's tracking campaign that is cookied on the customer's computer
  # @return [AffiliateLink] If the affiliate user's link campaign that is cookied on the customer's computer
  # @return [nil] Otherwise
  def get_affiliate_link
    affiliate_link = AffiliateLink.where(slug: cookies.signed[:tid]).first if cookies.signed[:tid]
    if affiliate_link
      affiliate_link
    else
      cookies.delete :tid
      nil
    end
  end

  def after_sign_in_path_for(user)
    if session[:last_login_at].present? && session[:last_login_at] > 5.seconds.ago
      session[:previous_url] = root_path
    end
    session[:last_login_at] = DateTime.now
    session[:previous_url] = nil if session[:previous_url] =~ /\/auth\//
    session[:previous_url] || root_path
  end

  protected

  def set_last_location
    if request.fullpath != '/login' && request.fullpath != '/logout' && !request.xhr?
      session[:previous_url] = request.fullpath
    end
  end

  def require_authentication
    redirect_to new_user_session_path and return unless current_user
  end

  def authenticate_staging
    if Rails.env.staging?
      authenticate_or_request_with_http_basic 'Staging' do |name, password|
        name == 'username' && password == 'password'
      end
    end
  end

  # Sets the common date for filtering data in the dashboards
  def set_common_date
    # From date
    @from = params[:from]
    @from = session[:from] unless @from
    @from = DateTime.current.to_date.beginning_of_month.to_s unless @from
    # To date
    @to = params[:to]
    @to = session[:to] unless @to
    @to = DateTime.current.to_date.end_of_month.to_s unless @to

    begin
      @from_date = Date.parse(@from.to_s) if @from
    rescue
      @from_date = DateTime.current.to_date.beginning_of_month.to_s
    end
    begin
      @to_date = Date.parse(@to.to_s) if @to
    rescue
      @to_date = DateTime.current.to_date.end_of_month.to_s
    end
    @to_date, @from_date = @from_date, @to_date if @to_date < @from_date
    session[:from] = @from_date
    session[:to] = @to_date
  end

  # Sets the meta tag for Ideal Me
  def set_meta
    title = "Are You Ready To Take The Ideal Me 'Dream Life' Challenge?"
    description = "12 Goals, One A Month, The Best Celeb Experts, Info & Products & Testing It For Max Results In Minimal Time To See What Works, What Doesn't And How To Become Your Ideal Me"
    image = ''
    set_meta_tags(og: { site_name: 'Ideal Me', title: title, description: description, type: :website, url: 'https://www.idealme.com', image: image },
                  fb: { admins: %w(100004702779319 278115168965598 470201106346280).join(',') },
                  twitter: { card: 'summary', title: title, description: description, image: image },
                  server: IM_HOSTNAME

    )
  end

  # Set the JavaScript gon object on the current window with the controller, action and the current user's ID
  def set_gon
    # Current controller
    gon.controller = params[:controller]
    # Current action
    gon.action = params[:action]
    # Set user ID if the user is logged in
    gon.current_user_id = current_user.id if current_user
    # Set user ID to null if no user is logged in
    gon.current_user_id = nil unless current_user
    # Set user ID if the user is logged in
    gon.current_user_username = current_user.username if current_user
    # Set user ID to null if no user is logged in
    gon.current_user_username = nil unless current_user

    if current_user
      gon.current_user_toured = current_user.toured
    end

    # CSRF token
    # if protect_against_forgery?
    gon.form_authenticity_token = form_authenticity_token.inspect
    # end
    gon.fullpath = request.fullpath
    gon.timezone = current_user.timezone if current_user
    gon.timezone = Rails.configuration.time_zone unless current_user
  end

  # Get the current affiliate tracking profile that is cookied on the user's computer
  #
  # @return [AffiliateLink] The current affiliate tracking profile that is cookied on the user's computer
  def get_affiliate_link
    AffiliateLink.where(slug: cookies.signed[:tid]).first
  end

  # Get the current affiliate user that is cookied on the user's computer
  #
  # @return [User] The current affiliate user that is cookied on the user's computer
  def get_affiliate_user
    User.where(affiliate_tag: cookies.signed[:zid]).first
  end

  # Sets the current timezone based on the current user's preferences
  def set_time_zone
    Time.zone = current_user.timezone if current_user && ActiveSupport::TimeZone[current_user.timezone]
  end

  # Instruct CanCan to not check authentication for devise controllers.
  #
  # Used to prevent CanCan from raising exceptions on devise controllers.
  def do_not_check_authorization?
    # This is a defined method in the devise gem which will return true of the current controller is a devise controller.
    respond_to?(:devise_controller?)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) << :username
    devise_parameter_sanitizer.for(:account_update) << :firstname
    devise_parameter_sanitizer.for(:account_update) << :lastname
    devise_parameter_sanitizer.for(:account_update) << :password
    devise_parameter_sanitizer.for(:account_update) << :password_confirmation
  end

  def set_conversion_partial
    @conversion_partial = session.delete :conversion_partial
  end
end
