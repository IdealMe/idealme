puts 'Seeding users'
u = User.create(:firstname => 'Bill', :lastname => 'IdealMe', :username => 'bill', :password => 'passpass',
                :email => 'bill@idealme.com', :tagline => 'Idealist - Coder - RoR', :affiliate_tag => 'billideal',
                :avatar => File.new("#{Rails.root.to_s}/db/seeds/users/images.jpg", 'r'),
                :instructor_about => '<p>Bill Li is a software developer, and he has been writing code since an early age, from ASP, PHP to Ruby.</p><p>He has been gaining weight at a tender age of 10, however, in the past ten years he has succesfully cooked steaks which will make Gordon Ramsay jealous.</p><p>I should have used lorem ipsum generator instead.</p>')
u.update_attributes({:access_admin => true, :access_affiliate => true, :access_instructor => true}, :as => :admin)
u.confirm!

%w(alice bob charlie david eden frank george hilbert ida jack kelly liam mike nancy).each do |user|
  u = User.create!(:firstname => user, :lastname => 'IdealMe', :username => user,
                   :password => 'passpass', :email => "#{user}@idealme.com",
                   :tagline => 'Idealist - User - RoR')
  u.confirm!
end
