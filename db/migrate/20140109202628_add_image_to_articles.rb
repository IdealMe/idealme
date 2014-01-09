class AddImageToArticles < ActiveRecord::Migration
  def change
    change_table :articles do |t|
      t.attachment :image
    end
  end
end
