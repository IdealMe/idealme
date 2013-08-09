class CreateGoalUsers < ActiveRecord::Migration
  def change
    create_table :goal_users do |t|
      t.boolean :private, :default => true

      t.boolean :archived, :default => false
      t.boolean :completed, :default => false


      t.belongs_to :user
      t.belongs_to :goal

      t.timestamps
    end
    add_index :goal_users, :user_id
    add_index :goal_users, :goal_id
  end
end
