namespace :users do

  desc "Load a bunch of fake users"
  task :load_fakes => :environment do
    require 'csv'
    require 'active_support/inflector'

    User.where(fake: true).destroy_all

    goals = Goal.all

    CSV.foreach('./fake_users.csv') do |row|
      next if row[0] == 'User'
      user = User.new
      user.fake = true
      user.firstname = row[0]
      user.lastname = row[1]
      user.username = User.generate_unique_username(user.firstname, user.lastname).parameterize('.')
      user.email = "fake_user_#{user.username}@idealme.com"
      user.password = SecureRandom.hex
      user.save!

      # For each fake user, add some random goals and courses

      goals.sample(rand(1..6)).each do |goal|
        user.subscribe_goal(goal)
      end

      user.goals.map(&:courses).flatten.sample(rand(0..3)).each do |course|
        user.subscribe_course(course)
      end

      user.goal_users.each do |goal_user|
        goal_user.update_attribute(:private, false)
      end

    end



  end

end