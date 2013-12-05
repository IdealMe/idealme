class AddWeightToGoalUsers < ActiveRecord::Migration
  def change
    add_column :goal_users, :weight, :integer, :default => 0
    add_column :goal_users, :position, :integer, :default => 0
  end
end
