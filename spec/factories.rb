FactoryGirl.define do
  factory :TestStudent do
    name "Maija"
    points 123
  end

  factory :Course do
    name "matikka1"
    coursekey "kurssiavain1"
    html_id "esimerkkihtmlid"
  end

end