puts 'Seeding categories'
['Health and wellness', 'Fitness', 'Learning', 'Mindfulness',
 'Happiness' 'Money and Financial', 'Relationships'].each do |c|
  Category.create(:name => c)
end