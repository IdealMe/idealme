FactoryGirl.define do
  factory :article do
    name Faker::Lorem.words(3).join(" ")
    content Faker::Lorem.paragraphs(5).join("\n\n ")
  end
end
