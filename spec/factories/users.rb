FactoryGirl.define do
  factory :user do
    firstname 'normal'
    lastname 'idealme'
    username 'normal_idealme'
    password 'passpass'
    email 'normal@idealme.com'
    confirmed_at Time.now

    factory :user2 do
      firstname 'jarblie'
      lastname 'wagonkus'
      username 'jarblie'
      email 'jarblie@idealme.com'
    end

    factory :user3 do
      firstname 'smirks'
      lastname 'caggish'
      username 'smirks'
      email 'smirks@idealme.com'
    end

    factory :user_admin do
      firstname 'admin'
      lastname 'idealme'
      username 'admin_idealme'
      email 'admin@idealme.com'
      access_admin true
    end

    factory :affiliate_user do
      firstname 'affiliate'
      lastname 'phil'
      username 'affiliate_phil_9000'
      email 'affiliate@idealme.com'
      affiliate_tag 'phil.deal'
      access_affiliate true
    end
  end
end
