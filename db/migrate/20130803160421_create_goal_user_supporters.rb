class CreateGoalUserSupporters < ActiveRecord::Migration
  def change
    create_table :goal_user_supporters do |t|
      t.integer :goal_user_id
      t.integer :supporter_id

      t.timestamps
    end

    add_index :goal_user_supporters, :goal_user_id
    add_index :goal_user_supporters, :supporter_id


  end
end
