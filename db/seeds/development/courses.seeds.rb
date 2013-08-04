[
{:name => 'Fresh Start! Raw Detox Diet', :cost => 700, :slider => true}, 
{:name => 'Fresh Start! Energizing Diet', :cost => 700, :slider => true}, 
{:name => '52 Indulgences', :cost => 700, :slider => true}, 
{:name => 'Hatha Yoga', :cost => 700, :slider => true}, 
{:name => 'The Lean Internet Business Certification System', :cost => 249700, :slider => false}, 
{:name => 'The Smarter Internet Marketer Tax Guide', :cost => 19700, :slider => false}, 
{:name => 'FB Shadow', :cost => 49700, :slider => false}, 
{:name => 'Webinar Lookin', :cost => 49700, :slider => false}, 
{:name => 'Get More Leads', :cost => 239100, :slider => false},  
{:name => 'Ask Brittany', :cost => 4700, :slider => false}, 
{:name => 'The Smarter Internet Marketer Tax Guide Plus Bootcamp', :cost => 99700, :slider => false}, 
{:name => 'Never Ending Motivation', :cost => 9700, :slider => false}, 
{:name => 'Thin And Healthy Online', :cost => 19700, :slider => false}, 
{:name => '5 Pillars Of Success - Life Hacks That Help You Achieve Anything', :cost => 19700, :slider => false}].each do |course|
  normalized = course[:name].gsub(/[^0-9a-z ]/i, '').squish.gsub(' ','-').downcase
  
  contents = File.open("#{Rails.root.to_s}/db/seeds/markets/#{normalized}.html", "r").read
  
  market = Market.create!(:name => course[:name], :hidden => false, :slider => course[:slider], :content => contents)
  course = Course.create!(:name => course[:name], :cost => course[:cost])

  course.owner = User.first
  course.default_market_id = market.id
  course.save

  market.course = course
  market.affiliate_tag = market.name.gsub(/(\w)\w+\W*/, '\1').downcase
  market.save
end


