class Admin::MarketsController < ApplicationController
  # GET /admin/markets
  def index
    @markets = Market.all
  end

  # GET /admin/markets/1
  def show
    @market = Market.find(params[:id])
  end

  # GET /admin/markets/new
  def new
    @market = Market.new
  end

  # GET /admin/markets/1/edit
  def edit
    @market = Market.find(params[:id])
  end

  # POST /admin/markets
  def create
    @market = Market.new(params[:market])
    if @market.save
      redirect_to admin_market_path(@market), notice: 'Market was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /admin/markets/1
  def update
    @market = Market.find(params[:id])

    respond_to do |format|
      if @market.update_attributes(params[:market])
        redirect_to admin_market_path(@market), notice: 'Market was successfully updated.'
      else
        render action: "edit"
      end
    end
  end

  # DELETE /admin/markets/1
  def destroy
    @market = Market.find(params[:id])
    @market.destroy
    redirect_to admin_markets_url
  end
end
