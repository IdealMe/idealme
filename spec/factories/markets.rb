FactoryGirl.define do
  factory :market do
    name 'Sample market'
    affiliate_tag 'at-market-tag'
    factory :market2 do
      name 'Another market'
      affiliate_tag 'at-other-market-tag'
    end
  end

end
