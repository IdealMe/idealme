class AffiliateLinksController < ApplicationController

  def perform
    link = AffiliateLink.where(slug: params[:slug]).first
    redirect_to root_path unless link
    redirect_to link.path if link
  end

end
