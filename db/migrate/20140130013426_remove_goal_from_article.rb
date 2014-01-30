class RemoveGoalFromArticle < ActiveRecord::Migration
  def change
    remove_column :articles, :goal_id
  end
end
