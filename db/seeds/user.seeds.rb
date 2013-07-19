User.create(:firstname => 'Bill', :lastname => 'Ideal', :username => 'bill', :password => 'passpass',
            :email => 'bill@idealme.com', :tagline => 'Idealist - Coder - RoR',
            :avatar => File.new("#{Rails.root.to_s}/db/seeds/users/images.jpg", 'r'))