FactoryGirl.define do
  factory :course do
    name 'Sample course'
    cost 99700
    affiliate_commission 50.0
    default_market_id 1
  end
end
