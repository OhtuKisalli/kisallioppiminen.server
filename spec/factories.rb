FactoryGirl.define do
  
  factory :user do
    username "hanipöö"
    name "Pertti"
    first_name "James"
    last_name "Bond"
    email "t1@t.t"
    password "qwerty"
  end

  factory :Course do
    name "math1"
    coursekey "coursekey1"
    html_id "this_htmlid"
  end
  
  factory :course do
    name "maa1"
    coursekey "key1"
  end
  
end
