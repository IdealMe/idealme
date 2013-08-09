FactoryGirl.define do
  factory :user do
    firstname 'normal'
    lastname 'idealme'
    username { "#{firstname}_#{lastname}" }
    password 'passpass'
    email { "#{firstname}_#{lastname}@idealme.com" }
    factory :user_admin do
      firstname 'admin'
      lastname 'idealme'
      access_admin true
    end
  end
end
