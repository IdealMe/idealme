# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :affiliate_link do
    slug 'my-link'
    market_tag 'market_tag'
    user { create(:affiliate_user) }
  end
end
