class AffiliateSale < ActiveRecord::Base
  # == Imports ==============================================================
  # == Slug =================================================================
  # == Constants ============================================================
  # == Attributes ===========================================================
  # == Relationships ========================================================
  # == Paperclip ============================================================
  # == Validations ==========================================================
  # == Scopes ===============================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # Create or find an affiliate initiated sale based on the order and the raw (value) affiliate user and tracking data
  def self.create_affiliate_sale(order, affiliate_user, affiliate_tracking=nil)
    if affiliate_user
      affiliate_sale = AffiliateSale.where(:order_id => order.id, :user_id => affiliate_user.id, :completed => false).first_or_create
      if affiliate_tracking
        affiliate_sale.affiliate_tracking_id = affiliate_tracking.id
      else
        affiliate_sale.affiliate_tracking_id = nil
      end
      affiliate_sale.save!
      affiliate_sale
    end
  end
  
  # == Instance Methods =====================================================
end
