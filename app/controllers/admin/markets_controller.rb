class Admin::MarketsController < Admin::BaseController
  before_filter :load_market, :only => [:show, :edit, :update, :destroy]
  before_filter :load_markets, :only => :index
  before_filter :build_market, :only => [:new, :create]

  # GET /admin/markets
  def index
  end

  # GET /admin/markets/1
  def show
  end

  # GET /admin/markets/new
  def new
  end

  # GET /admin/markets/1/edit
  def edit
  end

  # POST /admin/markets
  def create
    @market.save!
    redirect_to edit_admin_market_path(@market), :notice => 'Market was successfully created.'
  rescue ActiveRecord::RecordInvalid
    render :action => :new
  end

  # PUT /admin/markets/1
  def update
    @market.update_attributes!(params[:market])
    redirect_to edit_admin_market_path(@market), :notice => 'Market was successfully updated.'
  rescue ActiveRecord::RecordInvalid
    render :action => :edit
  end

  # DELETE /admin/markets/1
  def destroy
    @market.destroy
    redirect_to admin_markets_url, :notice => 'Market was successfully deleted'
  end


  protected
  def load_market
    @market = Market.find(params[:id])
    @market.features.build
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_markets_path, :alert => "Market not found"
  end

  def load_markets
    @markets = Market.all
  end

  def build_market
    @market = Market.new(params[:market])
    @market.features.build
  end

end

