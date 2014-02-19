class AddDripContentFieldsToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :drip_content, :boolean
    add_column :articles, :reveal_after_days, :integer
  end
end
