u = User.create(:firstname => 'Bill', :lastname => 'IdealMe', :username => 'bill', :password => 'passpass',
                :email => 'bill@idealme.com', :tagline => 'Idealist - Coder - RoR', :affiliate_tag => 'billideal',
                :avatar => File.new("#{Rails.root.to_s}/db/seeds/users/images.jpg", 'r'))

u.assign_attributes({:access_admin => true, :access_affiliate => true}, :as => :admin)
u.save


%w(alice bob charlie david eden frank george hilbert).each do |user|
  User.create(:firstname => user, :lastname => 'IdealMe', :username => user, :password => 'passpass',
              :email => "#{user}@idealme.com", :tagline => 'Idealist - Coder - RoR')
end