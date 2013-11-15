class AffiliateLink < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :market_tag, :slug, :user

  has_many :sales, class_name: 'AffiliateSale'
  has_many :affiliate_clicks


  def path(market_tag = nil)
    market_tag ||= self.market_tag
    "/markets/#{market_tag}/#{user.affiliate_tag}/#{slug}"
  end

  def market_id
    Market.where(affiliate_tag: market_tag).first.try(:id)
  end

  def market_id=(v)
    self.market_tag = Market.where(id: v).first.try(:affiliate_tag)
  end

  def market
    Market.find(market_id)
  end
end
