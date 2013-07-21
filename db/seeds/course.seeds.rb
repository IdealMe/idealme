after :users do
  Course.destroy_all
  Course.create!(:name => 'Fresh Start! Raw Detox Diet', :cost => 49700)
  Course.create!(:name => 'Fresh Start! Energizing Diet', :cost => 49700)
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

  users = User.all
  Course.find_each do |course|
    course.owner_id = 1
    course.default_market_id = course.id
    course.save
  end
end