class CreateCheckins < ActiveRecord::Migration
  def change
    create_table :checkins do |t|
      
      t.references :goal_user

      t.timestamps
    end
    add_index :checkins, :goal_user_id
  end
end
