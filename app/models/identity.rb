class Identity < ActiveRecord::Base
  belongs_to :owner, class_name: 'User'
  scope :facebook_identity, lambda { |owner| where(owner_id: owner.id) }
  scope :google_identity, lambda { |owner| where(owner_id: owner.id) }
end
