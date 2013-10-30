puts 'Seeding users'
u = User.find_or_create_by_email(firstname: 'Bill', lastname: 'IdealMe', username: 'bill', password: 'passpass',
                email: 'bill@idealme.com', tagline: 'Idealist - Coder - RoR', affiliate_tag: 'billideal',
                avatar: File.new("#{Rails.root.to_s}/db/seeds/users/images.jpg", 'r'),
                instructor_about: '<p>Bill Li is a software developer, and he has been writing code since an early age, from ASP, PHP to Ruby.</p><p>He has been gaining weight at a tender age of 10, however, in the past ten years he has succesfully cooked steaks which will make Gordon Ramsay jealous.</p><p>I should have used lorem ipsum generator instead.</p>')
u.update_attributes({access_admin: true, access_affiliate: true, access_instructor: true}, as: :admin)
u.confirm!

u = User.find_or_create_by_email(firstname: 'Charlie', lastname: 'Wilkins', username: 'charlie', password: '123123123',
                                 email: 'charlie@idealme.com', tagline: 'Idealist - Coder - RoR', affiliate_tag: 'charlieideal',
                                 avatar: File.new("#{Rails.root.to_s}/db/seeds/users/images.jpg", 'r'),
                                 instructor_about: '<p>Charlie!</p>')
u.update_attributes({access_admin: true, access_affiliate: true, access_instructor: true}, as: :admin)
u.confirm!

u = User.find_or_create_by_email(firstname: 'Charlie', lastname: 'Wilkins', username: 'charlie-notadmin', password: '123123123',
                                 email: 'charlie+notadmin@idealme.com', tagline: 'Idealist - Coder - RoR', affiliate_tag: 'charlieideal',
                                 avatar: File.new("#{Rails.root.to_s}/db/seeds/users/images.jpg", 'r'),
                                 instructor_about: '<p>Charlie!</p>')
u.update_attributes({access_admin: false, access_affiliate: false, access_instructor: false}, as: :admin)
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

  begin
    require ::File.expand_path("#{Rails.root.to_s}/db/seeds/markets/#{normalized}", __FILE__)
  rescue LoadError
    puts "#{normalized} was not found. Skipping."
  end
end

puts 'Seeding jewels'
['3Ro6o6okPFw', 'bDqr79kjmCE', 'XGFV4Ul9cEE', 'NGbZmcQg0lk', 'kiqRNoXuBgo', 'iYqtMfzLquA', 'oo-WU1madK4', 'TUFY_NixZCU',
 'Ji9NmckJ8g8', '0MiKp8CzcNs', '9EAhNgk6XPk', 'UZarVfjgHXY', '5KjC-lWTDtw', 'MmnSUI15X5s', 'tV_L-Cet7RA', 'bJlY_nl6MLo',
 'NblytNWvNRc', 'Nat0ZkZsumQ', 'vo8cB_3U3jQ', 'iWs6gwlTF5E', 'HvjziMbf0lg', 'APWjFMf4Hq4', 'Y4Zzs7IEIDQ', 'Y774exAPhsU',
 '1PTx051vFQo', 'cog-2wSxMYw', 'UAc-55GTX58', 'wKorJK3xEV0', 'SyG8yv8VzL0', 'tud1NdaSfhU', '67Dbl5D4N5w', 'ZwlW4800Fz0',
 'ijk1sCF48FI', 'jxSwnRoyGFU', '829BdEDQOzc', 'D288bP1Ep2c', 'SoMFts81zHw', '7dqBN6D6VGs', 'HRzIrCiXNEg', 'oO0pUJhzuiA',
 'K0PWoWh9Gog', '_mrJguOU40c'].each do |video|
  gem = Jewel.mine(User.last, "http://www.youtube.com/watch?v=#{video}")
end

['IohwMp6im1A', 'invCtzmdMs0', 'CDhIo7X77Mo'].each do |video|
  gem = Jewel.mine(User.first, "http://www.youtube.com/watch?v=#{video}")
end
