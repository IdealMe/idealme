FactoryGirl.define do
  factory :subscription do
    user { create(:affiliate_user) }

  end
end
