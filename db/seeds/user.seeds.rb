u = User.create(:firstname => 'Bill', :lastname => 'IdealMe', :username => 'bill', :password => 'passpass',
                :email => 'bill@idealme.com', :tagline => 'Idealist - Coder - RoR', :affiliate_tag => 'billideal',
                :avatar => File.new("#{Rails.root.to_s}/db/seeds/users/images.jpg", 'r'),
                :instructor_about => '<p>Bill Li is a software developer, and he has been writing code since an early age, from ASP, PHP to Ruby.</p><p>He has been gaining weight at a tender age of 10, however, in the past ten years he has succesfully cooked steaks which will make Gordon Ramsay jealous.</p><p>I should have used lorem ipsum generator instead.</p>')

u.assign_attributes({:access_admin => true, :access_affiliate => true, :access_instructor => true}, :as => :admin)
u.save

u.goals << Goal.first
u.goals << Goal.last

c = Course.create!(:name => 'Fresh Start! Raw Detox Diet', :cost => 49700)

u.courses << c

s = Section.create(:name => 'Fresh Start! Raw Detox Diet', :course => c)

Lecture.create(:name => 'Introductory Guide', :section => s)

s = Section.create(:name => 'Before You Start', :course => c)

Lecture.create(:name => 'Introduction', :section => s)
Lecture.create(:name => 'First Step FAQ', :section => s)
Lecture.create(:name => 'Grocery List', :section => s)

s = Section.create(:name => 'Advanced Raw Knowledge', :course => c)

Lecture.create(:name => 'Advanced Raw Knowledge', :section => s)
Lecture.create(:name => 'Tips Beyond Week One', :section => s)

s = Section.create(:name => 'Recipes', :course => c)

Lecture.create(:name => '7 Breakfast', :section => s)
Lecture.create(:name => '7 Lunches', :section => s)
Lecture.create(:name => '7 Dinners', :section => s)
Lecture.create(:name => '7 Juice & Desserts', :section => s)


s = Section.create(:name => 'Bonus', :course => c)


Lecture.create(:name => '36 Bonus Recipes', :section => s)
Lecture.create(:name => 'Juicing Guide', :section => s)
Lecture.create(:name => 'Nutrition Guide', :section => s)
Lecture.create(:name => 'Bonus Worksheets Days 1-7', :section => s)
Lecture.create(:name => 'Bonus Worksheets Days 7+', :section => s)


c = Course.create!(:name => 'Fresh Start! Energizing Diet', :cost => 49700)
u.courses << c
Course.create!(:name => '52 Indulgences', :cost => 49700)
Course.create!(:name => 'Hatha Yoga', :cost => 49700)
Course.create!(:name => 'The Lean Internet Business Certification System', :cost => 49700)
Course.create!(:name => 'The Smarter Internet Marketer Tax Guide', :cost => 49700)
Course.create!(:name => 'FB Shadow', :cost => 49700)
Course.create!(:name => 'Webinar Lookin', :cost => 49700)
Course.create!(:name => 'Get More Leads', :cost => 49700)
Course.create!(:name => 'Ask Brittany', :cost => 49700)
Course.create!(:name => 'The Smarter Internet Marketer Tax Guide Plus Bootcamp', :cost => 49700)
Course.create!(:name => 'Never Ending Motivation', :cost => 49700)
Course.create!(:name => 'Thin And Healthy Online', :cost => 49700)
Course.create!(:name => '5 Pillars Of Success - Life Hacks That Help You Achieve Anything', :cost => 49700)

Course.find_each do |course|
  course.owner = u
  course.default_market_id = course.id
  course.save
end


Market.create!(:name => 'Fresh Start! Raw Detox Diet', :hidden => false)
Market.create!(:name => 'Fresh Start! Energizing Diet', :hidden => false)
Market.create!(:name => '52 Indulgences', :hidden => false)
Market.create!(:name => 'Hatha Yoga', :hidden => false)
Market.create!(:name => 'The Lean Internet Business Certification System', :hidden => false, :slider => true)
Market.create!(:name => 'The Smarter Internet Marketer Tax Guide', :hidden => false)
Market.create!(:name => 'FB Shadow', :hidden => false)
Market.create!(:name => 'Webinar Lookin', :hidden => false)
Market.create!(:name => 'Get More Leads', :hidden => false)
Market.create!(:name => 'Ask Brittany', :hidden => false)
Market.create!(:name => 'The Smarter Internet Marketer Tax Guide Plus Bootcamp', :hidden => false, :slider => true)
Market.create!(:name => 'Never Ending Motivation', :hidden => false)
Market.create!(:name => 'Thin And Healthy Online', :hidden => false)
Market.create!(:name => '5 Pillars Of Success - Life Hacks That Help You Achieve Anything', :hidden => false, :slider => true)

Market.find_each do |market|
  market.course = Course.where(:name => market.name).first
  market.affiliate_tag = market.name.gsub(/(\w)\w+\W*/, '\1').downcase
  market.save
end


%w(alice bob charlie david eden frank george hilbert).each do |user|
  User.create(:firstname => user, :lastname => 'IdealMe', :username => user, :password => 'passpass',
              :email => "#{user}@idealme.com", :tagline => 'Idealist - Coder - RoR')
end                     