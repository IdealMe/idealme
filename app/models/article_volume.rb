class ArticleVolume < ActiveRecord::Base
  validates :article_source_id, presence: true
  validates :article_target_id, presence: true
  belongs_to :article_source, class_name: 'Article'
  belongs_to :article_target, class_name: 'Article'
end
