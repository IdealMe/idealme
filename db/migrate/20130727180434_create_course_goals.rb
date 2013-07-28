class CreateCourseGoals < ActiveRecord::Migration
  def change
    create_table :course_goals do |t|
      t.references :course
      t.references :goal

      t.timestamps
    end
    add_index :course_goals, :course_id
    add_index :course_goals, :goal_id
  end
end
