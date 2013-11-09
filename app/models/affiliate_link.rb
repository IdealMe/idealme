class AffiliateLink < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :market_tag, :slug, :user
  attr_accessible :slug, :market_tag, :tracking_tag, :market_id, :user_id

  has_many :sales, class_name: 'AffiliateSale'
  has_many :affiliate_clicks


  def path
    "/markets/#{market_tag}/#{user.affiliate_tag}#{tracking_tag_or_blank}"
  end

  def tracking_tag_or_blank
    if tracking_tag
      "/#{tracking_tag}"
    else
      ""
    end
  end

  def market_id
    Market.where(affiliate_tag: market_tag).first.try(:id)
  end

  def market_id=(v)
    self.market_tag = Market.where(id: v).first.try(:affiliate_tag)
  end
end
