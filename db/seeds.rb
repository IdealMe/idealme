puts 'Seeding users'
u = User.find_or_create_by_email(firstname: 'Admin', lastname: 'User', username: 'adminuser', password: '123123123', password_confirmation: '123123123',
                                 email: 'admin@idealme.com', tagline: '', affiliate_tag: 'adminideal',
                                 avatar: File.new("#{Rails.root.to_s}/db/seeds/users/images.jpg", 'r'),
                                 instructor_about: '<p>Admin User!</p>')
u.update_attributes({access_admin: true, access_affiliate: true, access_instructor: true})
u.confirm!

u = User.find_or_create_by_email(firstname: 'Affiliate', lastname: 'User', username: 'affiliateuser', password: '123123123',
                                 email: 'affiliate@idealme.com', tagline: '', affiliate_tag: 'affiliateideal',
                                 avatar: File.new("#{Rails.root.to_s}/db/seeds/users/images.jpg", 'r'),
                                 instructor_about: '<p>Affiliate User!</p>')
u.update_attributes({access_admin: false, access_affiliate: true, access_instructor: false})
u.confirm!

u = User.find_or_create_by_email(firstname: 'User', lastname: 'User', username: 'useruser', password: '123123123',
                                 email: 'user@idealme.com',
                                 avatar: File.new("#{Rails.root.to_s}/db/seeds/users/images.jpg", 'r'),
                                 instructor_about: '<p>User User!</p>')
u.update_attributes({access_admin: false, access_affiliate: false, access_instructor: false})
u.confirm!

unless Rails.env.production?
	%w(alice bob david eden frank george hilbert ida jack kelly liam mike nancy).each do |user|
	  u = User.find_or_create_by_email(firstname: user, lastname: 'IdealMe', username: user,
	                   password: 'passpass', email: "#{user}@idealme.com",
	                   tagline: 'Idealist - User - RoR')
	  u.confirm!
	end
end

puts 'Seeding checkins'
User.find_each do |user|
  user.goal_users.each do |goal_user|
  	(0..21).each do |x|
  	  checkin = Checkin.new({created_at: DateTime.now - x.days}, without_protection: true)
  	  checkin.save!
      goal_user.checkins << checkin
    end
  end
end

puts 'Seeding sites'
cms = Cms::Site.find_or_create_by_identifier(label: 'idealme', identifier: 'idealme', hostname: 'idealme.com',
                        path: '/', locale: 'en', is_mirrored: false)
if Rails.env.staging?
  cms.hostname = 'idealmedev.com'
elsif Rails.env.development?
  cms.hostname = 'idealme.dev'
end
cms.save!

puts 'Seeding categories'
['Health and wellness', 'Fitness', 'Money and Financial', 'Learning',
 'Mindfulness', 'Happiness', 'Relationships'].each do |c|
  normalized = c.gsub(/[^0-9a-z ]/i, '').squish.gsub(' ', '-').downcase
  begin
    avatar = File.new("#{Rails.root.to_s}/db/seeds/categories/#{normalized}.png", "r")
  rescue Errno::ENOENT
    avatar = nil
  end

  Category.find_or_create_by_name(name: c, avatar: avatar)
end

puts 'Seeding goals'
['Lose weight', 'Learn to cook', 'Build a business', 'Relax more', 'Be more productive', 'Write a book',
 'Travel the world', 'Learn to dance', 'Learn to surf', 'Automate my finances', 'Learn to play an instrument',
 'Meditate', 'Learn a language', 'Understand investing', 'Master photography'].each_with_index do |goal, i|
  Goal.find_or_create_by_name(
    name: goal,
    welcome: true,
    ordering: i + 1,
    avatar: File.new("#{Rails.root.to_s}/db/seeds/goals/#{goal.gsub(' ', '_').downcase}.png", 'r'))
end

puts 'Seeding goal_users'
Goal.find_each do |goal|
  User.find_each do |user|
    user.subscribe_goal(goal)
  end
end

puts 'Seeding markets and courses'
[{name: 'Fresh Start! Raw Detox Diet', cost: 700, slider: true},
 {name: 'Fresh Start! Energizing Diet', cost: 700, slider: true},
 {name: '52 Indulgences', cost: 700, slider: true},
 {name: 'Hatha Yoga', cost: 700, slider: true},
 {name: 'The Lean Internet Business Certification System', cost: 249700, slider: false},
 {name: 'The Smarter Internet Marketer Tax Guide', cost: 19700, slider: false},
 {name: 'FB Shadow', cost: 49700, slider: false},
 {name: 'Webinar Lookin', cost: 49700, slider: false},
 {name: 'Get More Leads', cost: 239100, slider: false},
 {name: 'Ask Brittany', cost: 4700, slider: false},
 {name: 'The Smarter Internet Marketer Tax Guide Plus Bootcamp', cost: 99700, slider: false},
 {name: 'Never Ending Motivation', cost: 9700, slider: false},
 {name: 'Thin And Healthy Online', cost: 19700, slider: false},
 {name: '5 Pillars Of Success - Life Hacks That Help You Achieve Anything', cost: 19700, slider: false}].each do |course|
  normalized = course[:name].gsub(/[^0-9a-z ]/i, '').squish.gsub(' ', '-').downcase
  contents = File.open("#{Rails.root.to_s}/db/seeds/markets/#{normalized}.html", "r").read
  begin
    avatar = File.new("#{Rails.root.to_s}/db/seeds/markets/#{normalized}.png", "r")
  rescue Errno::ENOENT
    avatar = nil
  end

  market = Market.find_or_create_by_name(name: course[:name], hidden: false, slider: course[:slider], content: contents, avatar: avatar)
  course = Course.find_or_create_by_name(name: course[:name], cost: course[:cost])

  course.owner = User.first
  course.default_market_id = market.id
  course.save

  market.course = course
  market.affiliate_tag = market.name.gsub(/(\w)\w+\W*/, '\1').downcase
  market.save

  #begin
    #require ::File.expand_path("#{Rails.root.to_s}/db/seeds/markets/#{normalized}", __FILE__)
  #rescue LoadError
    #puts "#{normalized} was not found. Skipping."
  #end
end

puts 'Seeding jewels'
['63NNuG-6-hQ','3ENNbC_UmEM', 'KKKX3KCZaOw'].each do |video|
  gem = Jewel.mine(User.last, "http://www.youtube.com/watch?v=#{video}", Goal.where(name: 'Lose weight').first)
end

[
  'http://lifehacker.com/clip-better-adds-link-previews-to-emails-to-provide-con-1495624099',
  'http://uncrate.com/stuff/clearview-clio-speaker/',
].each do |link|
  gem = Jewel.mine(User.last, link, Goal.where(name: 'Lose weight').first)
end

Jewel.all.each { |jewel| jewel.update_column(:visible, true) }



