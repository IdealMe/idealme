class AffiliateClick < ActiveRecord::Base
  # == Imports ==============================================================
  # == Slug =================================================================
  # == Constants ============================================================
  # == Attributes ===========================================================
  attr_accessible :clicks, :ip, :tracking_code, :user_agent, :user_id, :affiliate_link_id, :created_at

  # == Relationships ========================================================
  belongs_to :affiliate_link
  belongs_to :user
  belongs_to :order

  # == Paperclip ============================================================
  # == Validations ==========================================================
  validates_presence_of :user

  # == Scopes ===============================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  def self.track(affiliate_user, ip, ua, tracking_code, affiliate_link=nil)
    if affiliate_link
      click = AffiliateClick.where(user_id: affiliate_user.id, affiliate_link_id: affiliate_link.id, ip: ip, user_agent: ua, tracking_code: tracking_code).where('created_at >= ?', Time.now.beginning_of_day).first
    else
      click = AffiliateClick.where(user_id: affiliate_user.id, affiliate_link_id: nil,               ip: ip, user_agent: ua, tracking_code: tracking_code).where('created_at >= ?', Time.now.beginning_of_day).first
    end
    if click
      click.clicks += 1
      click.save!
    else
      if affiliate_link
        click = AffiliateClick.create!(clicks: 1, user_id: affiliate_user.id, affiliate_link_id: affiliate_link.id, ip: ip, user_agent: ua, tracking_code: tracking_code, created_at: Time.now.beginning_of_day)
      else
        click = AffiliateClick.create!(clicks: 1, user_id: affiliate_user.id, affiliate_link_id: nil,               ip: ip, user_agent: ua, tracking_code: tracking_code, created_at: Time.now.beginning_of_day)
      end
    end
    click
  end

  # == Instance Methods =====================================================
end
