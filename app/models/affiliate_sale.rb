class AffiliateSale < ActiveRecord::Base
  # == Imports ==============================================================
  # == Slug =================================================================
  # == Constants ============================================================
  # == Attributes ===========================================================
  attr_accessible :user_id, :order_id, :affiliate_tracking_id

  # == Relationships ========================================================


  belongs_to :affiliate_tracking
  belongs_to :order
  belongs_to :user

  # == Paperclip ============================================================
  # == Validations ==========================================================
  # == Scopes ===============================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # Create or find an affiliate initiated sale based on the order and the raw (value) affiliate user and tracking data
  def self.create_affiliate_sale(order, affiliate_user, affiliate_link=nil)
    affiliate_sale = nil
    if affiliate_user && order
      affiliate_sale = AffiliateSale.create!(order_id: order.id, user_id: affiliate_user.id)
      if affiliate_link
        affiliate_sale.affiliate_link_id = affiliate_link.id
        affiliate_sale.save!
      end
    end
    affiliate_sale
  end

  # == Instance Methods =====================================================
end
