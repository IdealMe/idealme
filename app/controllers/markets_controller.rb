class MarketsController < ApplicationController
  # GET /markets
  before_filter :load_market, :only => :show
  before_filter :load_markets, :only => :index

  def index
  end

  # GET /markets/1
  def show
  end

  protected
  def load_market
    @market = Market.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to markets_path, :alert => 'Market not found.'
  end

  def load_markets
    @markets = Market.all
    @sliders = Market.slider.with_course_and_owner.all
  end
end
