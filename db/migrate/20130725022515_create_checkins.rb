class CreateCheckins < ActiveRecord::Migration
  def change
    create_table :checkins do |t|
      t.references :goal_user
      t.text :thoughts
      t.integer :up_votes, :default => 0
      t.integer :down_votes, :default => 0
      t.timestamps
    end
    add_index :checkins, :goal_user_id
  end
end
