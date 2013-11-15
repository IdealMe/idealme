class GoalUserSupporter < ActiveRecord::Base
  belongs_to :goal_user
  belongs_to :supporter, class_name: 'User', foreign_key: 'supporter_id', primary_key: 'id'
end
