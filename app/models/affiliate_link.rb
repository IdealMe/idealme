class AffiliateLink < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :market_tag, :slug, :user


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
end
