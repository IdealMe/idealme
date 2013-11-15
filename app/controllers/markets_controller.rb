class MarketsController < ApplicationController
  # GET /markets
  before_filter :load_market, only: :show
  before_filter :load_markets, only: :index


  def affiliate_init
    tracking_affiliate_tag = params.permit(:tracking_affiliate_tag)[:tracking_affiliate_tag]
    market_affiliate_tag = params.permit(:market_affiliate_tag)[:market_affiliate_tag]
    user_affiliate_tag = params.permit(:user_affiliate_tag)[:user_affiliate_tag]
    # Find the affiliate user
    affiliate_user = User.get_affiliate_user(user_affiliate_tag).first
    if affiliate_user
      # Sets the cookie for affiliate
      cookies.signed[:zid] = {value: affiliate_user.affiliate_tag, expires: 30.day.from_now}

      # We are going to delete the cookies for affiliate tracking
      cookies.delete :tid

      # Tracking clicks
      last_click = cookies.signed[:cid]
      if last_click.nil?
        last_click = Digest::SHA1.hexdigest("#{request.remote_ip}#{request.env['HTTP_USER_AGENT']}#{get_affiliate_user.id}#{DateTime.now.to_s}")
        cookies.signed.permanent[:cid] = {value: last_click}
      end

      # Find the affiliate tracking if one is provided
      affiliate_link = AffiliateLink.where(slug: tracking_affiliate_tag).first if tracking_affiliate_tag
      if affiliate_link
        cookies.signed[:tid] = {value: affiliate_link.slug, expires: 30.day.from_now}
        AffiliateClick.track(affiliate_user, request.remote_ip, request.env['HTTP_USER_AGENT'], last_click, affiliate_link)
      else
        AffiliateClick.track(affiliate_user, request.remote_ip, request.env['HTTP_USER_AGENT'], last_click, nil)
      end
    end

    # Find the market that was provided
    market = Market.where(affiliate_tag: market_affiliate_tag).first

    # Off to the market place
    redirect_to market_path market and return if market

binding.pry
    # Redirect to the market place if the market if not found, but the affiliate cookies are still set
    redirect_to markets_path
  end

  def index
  end

  # GET /markets/1
  def show
    @course = @market.course
  end

  protected
  def load_market
    @market = Market.find(params[:id])
    @payloads = Payload.compute_payload_tags(@market)
    @polls = PollQuestion.compute_poll_question_tags

  rescue ActiveRecord::RecordNotFound
binding.pry
    redirect_to markets_path, alert: 'Market not found.'
  end

  def load_markets
    @courses = Course.all.sort do |a,b|
      b.users.count <=> a.users.count
    end
    @sliders = Market.slider.with_course_and_owner
  end
end
