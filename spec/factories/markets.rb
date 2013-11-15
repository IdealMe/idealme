FactoryGirl.define do
  factory :market do
    name 'Sample market'
    affiliate_tag 'at-market-tag'
    content 'hey there, come try this course!'
    factory :market2 do
      name 'Another market'
      affiliate_tag 'at-other-market-tag'
    end
  end

end
