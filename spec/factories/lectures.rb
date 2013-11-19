FactoryGirl.define do
  factory :lecture do
    name "The First Lecture"
    description "hile the wounded were carted off to one area of the camp, she and the other healthy refugees were ushered to a large tent. Before entering it, they were subjected to a thorough and invasive search, in which suspect items were tossed on the ground by the guards"
    section_id { Section.last.id }
  end
end
