class ArticleCourse < ActiveRecord::Base
  belongs_to :article
  belongs_to :course
  attr_accessible :sequence
end
