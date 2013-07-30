class Vote < ActiveRecord::Base
  belongs_to :votable

  belongs_to :owner, :class_name => 'User'

  attr_accessible :down_vote, :owner_id, :up_vote, :votable_id, :votable_type
end
