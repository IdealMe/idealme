class GoalCourse < ActiveRecord::Base
  belongs_to :goal
  belongs_to :course
  # attr_accessible :title, :body
end
