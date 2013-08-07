puts 'Seeding goal_users'
Goal.find_each do |goal|
  User.find_each do |user|
    user.subscribe_goal(goal)
  end
end