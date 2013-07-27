class DiscoversController < ApplicationController
  # GET /discovers
  def index
    @discovers = Jewel.all

  end

  # GET /discovers/1
  def show
  end
end
