class CreateArticleGoal < ActiveRecord::Migration
  def change
    create_table :article_goals do |t|
      t.references :article
      t.references :goal
    end
  end
end
