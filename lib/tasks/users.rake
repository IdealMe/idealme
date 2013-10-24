namespace :users do

  desc "Load a bunch of fake users"
  task :load_fakes => :environment do
    require 'csv'
    require 'active_support/inflector'
    CSV.foreach('./fake_users.csv') do |row|
      next if row[0] == 'User'
      user = User.new
      user.fake = true
      user.firstname = row[0]
      user.lastname = row[1]
      user.username = User.generate_unique_username(user.firstname, user.lastname).parameterize('.')
      user.email = "fake_user_#{user.username}@idealme.com"
      user.password = SecureRandom.hex
      ap user.username
    end
  end

end