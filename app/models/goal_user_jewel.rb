class GoalUserJewel < ActiveRecord::Base
  belongs_to :goal
  belongs_to :goal_user
  belongs_to :jewel
  # attr_accessible :title, :body
end
