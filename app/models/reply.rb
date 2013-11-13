class Reply < ActiveRecord::Base
  belongs_to :comment
  belongs_to :owner, class_name: 'User'
end
