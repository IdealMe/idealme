class MarketFeature < ActiveRecord::Base
  attr_accessible :description, :avatar, :market_id

  belongs_to :market
end
