class CourseGoal < ActiveRecord::Base
  belongs_to :course
  belongs_to :goal
  # attr_accessible :title, :body

  attr_accessible :goal_id, :course_id
end
