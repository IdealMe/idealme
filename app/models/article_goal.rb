class ArticleGoal < ActiveRecord::Base
  belongs_to :goal
  belongs_to :article
end
