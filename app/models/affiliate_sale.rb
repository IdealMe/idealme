class AffiliateSale < ActiveRecord::Base
  # == Imports ==============================================================
  # == Slug =================================================================
  # == Constants ============================================================
  # == Attributes ===========================================================
  # == Relationships ========================================================

  belongs_to :affiliate_link
  belongs_to :order
  belongs_to :user

  # == Paperclip ============================================================
  # == Validations ==========================================================
  # == Scopes ===============================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # Create or find an affiliate initiated sale based on the order and the raw (value) affiliate user and tracking data
  def self.create_affiliate_sale(order, affiliate_user, affiliate_link = nil)
    affiliate_sale = nil
    if affiliate_user && order
      affiliate_sale = AffiliateSale.create!(order_id: order.id, user_id: affiliate_user.id)
      affiliate_sale.update_attribute(:completed, true) if order.status == Order::STATUS_SUCCESSFUL
      if affiliate_link
        affiliate_sale.affiliate_link_id = affiliate_link.id
        affiliate_sale.save!
      end
    end
    affiliate_sale
  end

  # == Instance Methods =====================================================
end
