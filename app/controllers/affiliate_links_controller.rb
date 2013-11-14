class AffiliateLinksController < ApplicationController
  def perform
    link = AffiliateLink.where(slug: params[:slug]).first
    if link
      redirect_to link.path(params[:market_tag])
    else
      redirect_to root_path
    end
  end
end
