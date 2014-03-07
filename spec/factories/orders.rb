FactoryGirl.define do
  factory :order do
    product :course
    user
    card_firstname { user.firstname }
    card_lastname { user.lastname }
    card_email { user.email }
    cost 4700
    gateway 3
    card_type "visa"
    card_number '4242424242424242'
    card_cvv 123
    card_number_4 4242
    card_exp_year 2023
    card_exp_month 3
  end
end
