class DiscoversController < ApplicationController
  # GET /discovers
  def index
    @discovers = Market.all

  end

  # GET /discovers/1
  def show
  end
end
