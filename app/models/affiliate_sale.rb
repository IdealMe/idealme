class AffiliateSale < ActiveRecord::Base
  # == Imports ==============================================================
  # == Slug =================================================================
  # == Constants ============================================================
  # == Attributes ===========================================================
  attr_accessible :user_id, :order_id, :affiliate_tracking_id

  # == Relationships ========================================================
  # == Paperclip ============================================================
  # == Validations ==========================================================
  # == Scopes ===============================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # Create or find an affiliate initiated sale based on the order and the raw (value) affiliate user and tracking data
  def self.create_affiliate_sale(order, affiliate_user, affiliate_tracking=nil)
	affiliate_sale = nil
    if affiliate_user && order
      affiliate_sale = AffiliateSale.create!(:order_id => order.id, :user_id => affiliate_user.id)
      if affiliate_tracking
        affiliate_sale.affiliate_tracking_id = affiliate_tracking.id
	    affiliate_sale.save!
      end
    end
	affiliate_sale
  end
  
  # == Instance Methods =====================================================
end
