class AddOriginalUrlToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :original_url, :text
  end
end
