FactoryGirl.define do
  
  factory :user do
    first_name "James"
    last_name "Bond"
    email "t1@t.t"
    password "qwerty"
  end
  
  factory :course do
    name "maa1"
    coursekey "key1"
    html_id "maa1"
    exerciselist_id do
      FactoryGirl.create(:exerciselist, html_id: html_id).id
    end
    
  end
  
  factory :exerciselist do
    html_id "maa1"
  end
  
end
