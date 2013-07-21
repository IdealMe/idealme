after :users do
  Market.destroy_all
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
    course = Course.where(:name => market.name).first
    market.course = course
    market.affiliate_tag = market.name.gsub(/(\w)\w+\W*/, '\1').downcase
    market.save
  end
end