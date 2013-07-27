class CreateGoalCourses < ActiveRecord::Migration
  def change
    create_table :goal_courses do |t|
      t.references :goal
      t.references :course

      t.timestamps
    end
    add_index :goal_courses, :goal_id
    add_index :goal_courses, :course_id
  end
end
