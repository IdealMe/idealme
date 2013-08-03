class Activity < ActiveRecord::Base
  serialize :parameters

  belongs_to :sender, :polymorphic => true
  belongs_to :trackable, :polymorphic => true
  attr_accessible :action, :count, :share_key, :parameters, :read, :sender, :trackable, :sender_id, :sender_type


  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :replies, :through => :comments

end
