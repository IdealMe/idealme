# a review needs an owner and course
FactoryGirl.define do
  factory :review do
    content 'This course was awesome and now I can levitate'
    recommended true
    factory :bad_review do
      content 'this course sucked'
      recommended false
    end
  end
end
