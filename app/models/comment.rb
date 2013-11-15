class Comment < ActiveRecord::Base

  has_many :replies, dependent: :destroy


  belongs_to :owner, class_name: 'User'
  belongs_to :commentable, polymorphic: true


  attr_accessor :redirect_back_to

  validates_length_of :content, minimum: 1, allow_blank: false


  scope :for, lambda { |object| where(commentable_id: object.id, commentable_type: object.class) }

end
