FactoryGirl.define do
  factory :TestStudent do
    name "Maija"
    points 123
  end

  factory :User do
    username "hanipöö"
    name "Pertti"
  end

  factory :Course do
    name "math1"
    coursekey "coursekey1"
    html_id "this_htmlid"
  end

end