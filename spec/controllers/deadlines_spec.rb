require 'rails_helper'

RSpec.describe DeadlinesController, type: :controller do
  
  describe "Teacher – I can create schedule for course" do
  
    context "when not logged in" do
      it "gives error message" do
        post 'newdeadline', :format => :json, params: {"id":1}
        expect(response.status).to eq(401)
        body = JSON.parse(response.body)
        expected = {"error" => "Sinun täytyy ensin kirjautua sisään."}
        expect(body).to eq(expected)
      end
    end
    
    context "params" do
      before(:each) do
        @course = FactoryGirl.create(:course, coursekey:"key1")
        @ope = FactoryGirl.create(:user, username:"ope1", email:"ope1@o.o")
        Teaching.create(user_id: @ope.id, course_id: @course.id)
        sign_in @ope
      end
      it "description necessary" do
        post 'newdeadline', :format => :json, params: {"id": 1, "deadline": "2017-03-04 23:59:59", "exercises": ["1","2","3"]}
        expect(response.status).to eq(422)
        body = JSON.parse(response.body)
        expected = {"error" => "Aikataululla täytyy olla nimi."}
        expect(body).to eq(expected)
      end
      it "deadline necessary" do
        post 'newdeadline', :format => :json, params: {"id": 1, "description": "nimi", "exercises": ["1","2","3"]}
        expect(response.status).to eq(422)
        body = JSON.parse(response.body)
        expected = {"error" => "Aikataululla täytyy olla päivämäärä."}
        expect(body).to eq(expected)
      end
      it "exercises necessary" do
        post 'newdeadline', :format => :json, params: {"id": 1, "description": "nimi", "deadline": "2017-03-04 23:59:59"}
        expect(response.status).to eq(422)
        body = JSON.parse(response.body)
        expected = {"error" => "Aikataululla täytyy olla vähintään yksi tehtävä."}
        expect(body).to eq(expected)
      end
      it "exercises cant be empty" do
        post 'newdeadline', :format => :json, params: {"id": 1, "description": "nimi","deadline": "2017-03-04 23:59:59", "exercises": []}
        expect(response.status).to eq(422)
        body = JSON.parse(response.body)
        expected = {"error" => "Aikataululla täytyy olla vähintään yksi tehtävä."}
        expect(body).to eq(expected)
      end
      it "must be at least one exercise " do
        post 'newdeadline', :format => :json, params: {"id": 1, "description": "nimi","deadline": "2017-03-04 23:59:59", "exercises": ["1"]}
        body = JSON.parse(response.body)
        expected = {"error" => "Aikataululla täytyy olla vähintään yksi tehtävä."}
        expect(body).not_to eq(expected)
      end
    end
        
    context "with proper params" do
      before(:each) do
        @course = FactoryGirl.create(:course, coursekey:"key1")
        @exercise1 = Exercise.create(course_id: @course.id, html_id:"id1")  
        @exercise2 = Exercise.create(course_id: @course.id, html_id:"id2")
        @exercise3 = Exercise.create(course_id: @course.id, html_id:"id3")
        @exercise4 = Exercise.create(course_id: @course.id, html_id:"id4")
        @course2 = FactoryGirl.create(:course, coursekey:"key2")
        @exercise5 = Exercise.create(course_id: @course2.id, html_id:"id1")  
        @exercise6 = Exercise.create(course_id: @course2.id, html_id:"id2")
        @opiskelija = FactoryGirl.create(:user, username:"o1", email:"o1@o.o")
        @ope = FactoryGirl.create(:user, username:"ope1", email:"ope1@o.o")
        Teaching.create(user_id: @ope.id, course_id: @course.id)
        @ope2 = FactoryGirl.create(:user, username:"ope2", email:"ope2@o.o")
        Teaching.create(user_id: @ope2.id, course_id: @course2.id)
        @exercises_param = []
        @exercises_param << @exercise1.html_id
        @exercises_param << @exercise3.html_id
      end
      it "must be teacher of the course" do
        sign_in @ope2
        post 'newdeadline', :format => :json, params: {"id": @course.id, "description": "nimi","deadline": "2017-03-04 23:59:59", "exercises": ["id1"]}
        expect(response.status).to eq(401)
        body = JSON.parse(response.body)
        expected = {"error" => "Et ole kyseisen kurssin vastuuhenkilö."}
        expect(body).to eq(expected)
      end
      it "saves deadline correctly" do
        sign_in @ope
        post 'newdeadline', :format => :json, params: {"id": @course.id, "description": "nimi","deadline": "2017-03-04 23:59:59", "exercises": @exercises_param}
        expect(response.status).to eq(200)
        expect(Deadline.first.description).to eq("nimi")
        expect(Deadline.first.deadline).to eq("2017-03-04 23:59:59")
        expect(Deadline.first.exercises.count).to eq(2)
        expect(Deadline.first.exercises.first.html_id).to eq(@exercise1.html_id)
        expect(Deadline.first.exercises.first.id).to eq(@exercise1.id)
        expect(Deadline.first.exercises.last.html_id).to eq(@exercise3.html_id)
        expect(Deadline.first.exercises.last.id).to eq(@exercise3.id)
        expect(Schedule.all.count).to eq(2)
        expect(Schedule.first.exercise_id).to eq(@exercise1.id)
        expect(Schedule.first.deadline_id).to eq(Deadline.first.id)
        expect(Schedule.last.exercise_id).to eq(@exercise3.id)
        expect(Schedule.last.deadline_id).to eq(Deadline.first.id)
        expect(Deadline.first.exercises.count).to eq(2)
        expect(@exercise1.deadlines.count).to eq(1)
        expect(@exercise2.deadlines.count).to eq(0)
        expect(@exercise3.deadlines.count).to eq(1)
        expect(@exercise4.deadlines.count).to eq(0)
        expect(@exercise5.deadlines.count).to eq(0)
        expect(@exercise6.deadlines.count).to eq(0)
      end
            
    end
      
  end

end
