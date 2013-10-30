class Reply < ActiveRecord::Base
  belongs_to :comment
  belongs_to :owner, class_name: 'User'
  attr_accessible :content, :owner_id
end
