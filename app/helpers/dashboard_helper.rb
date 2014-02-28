module DashboardHelper
  def market_tags_for_select
    Market.all.map do |market|
      ["#{market.name} (#{market.affiliate_tag})", market.affiliate_tag]
    end
  end
end
