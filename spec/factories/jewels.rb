
FactoryGirl.define do
  factory :jewel do
    name 'first example gem'
    url 'http://www.youtube.com/watch?v=ihxYRUiYz3s'
    visible true

    factory :course_jewel do
      kind Jewel::TYPES[:course] 
    end
    factory :article_jewel do
      kind Jewel::TYPES[:article] 
    end
    factory :app_jewel do
      kind Jewel::TYPES[:app] 
    end
    factory :product_jewel do
      kind Jewel::TYPES[:product] 
    end
    factory :video_jewel do
      kind Jewel::TYPES[:video] 
    end
  end
end
