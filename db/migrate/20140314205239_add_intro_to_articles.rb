class AddIntroToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :intro, :boolean, default: false
  end
end
