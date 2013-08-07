class ArticleAuthor < ActiveRecord::Base
  attr_accessible :author_id, :article_id
  belongs_to :article
  belongs_to :author, :class_name => 'User'
end
