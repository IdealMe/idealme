FactoryGirl.define do
  factory :comment do
    content "Lorem ipsum"
    owner User.last
    commentable Course.last
  end
end
