# a review needs an owner and course
FactoryGirl.define do
  factory :review do
    content 'This course was awesome and now I can levitate'
    title 'loved it'
    recommended true
    factory :bad_review do
      content 'this course sucked'
      title 'hated it'
      recommended false
    end
  end
end
