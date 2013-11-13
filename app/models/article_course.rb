class ArticleCourse < ActiveRecord::Base
  belongs_to :article
  belongs_to :course
end
