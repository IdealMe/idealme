class Fragment < ActiveRecord::Base
  validates_presence_of :name, :html
  extend FriendlyId

  friendly_id :name, use: [:history, :slugged, :finders]

end
