puts 'Seeding checkins'
User.find_each do |user|
  user.goal_users.each do |goal_user|
  	(0..21).each do |x|
  	  checkin = Checkin.new({:created_at => DateTime.now - x.days}, :without_protection => true)
  	  checkin.save!
      goal_user.checkins << checkin
    end
  end
end
