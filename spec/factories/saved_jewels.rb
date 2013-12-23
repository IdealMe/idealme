FactoryGirl.define do
  factory :saved_jewel do
    user User.last
    jewel Jewel.last
  end
end
