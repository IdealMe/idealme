puts 'Seeding categories'
['Health and wellness', 'Fitness', 'Money and Financial', 'Learning',
 'Mindfulness', 'Happiness', 'Relationships'].each do |c|
  normalized = c.gsub(/[^0-9a-z ]/i, '').squish.gsub(' ', '-').downcase
  begin
    avatar = File.new("#{Rails.root.to_s}/db/seeds/categories/#{normalized}.png", "r")
  rescue Errno::ENOENT
    avatar = nil
  end

  Category.create!(:name => c, :avatar => avatar)
end