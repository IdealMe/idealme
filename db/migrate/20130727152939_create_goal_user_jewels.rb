class CreateGoalUserJewels < ActiveRecord::Migration
  def change
    create_table :goal_user_jewels do |t|
      t.references :goal
      t.references :goal_user
      t.references :jewel

      t.timestamps
    end
    add_index :goal_user_jewels, :goal_id
    add_index :goal_user_jewels, :goal_user_id
    add_index :goal_user_jewels, :jewel_id
  end
end
