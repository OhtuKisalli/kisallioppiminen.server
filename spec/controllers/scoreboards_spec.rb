require 'rails_helper'
require 'date'

RSpec.describe ScoreboardsController, type: :controller do

  describe "get student scoreboard(s)" do
    context "when not logged in " do
      it "gives error message for a scoreboard" do
        get 'student_scoreboard', :format => :json, params: {"sid": "1","cid":"1"}
        expect(response.status).to eq(401)
      end
      it "gives error message for scoreboards" do
        get 'student_scoreboards', :format => :json, params: {"id":"1"}
        expect(response.status).to eq(401)
      end
    end
    
    context "when logged in" do
      before(:each) do
        @course1 = FactoryGirl.create(:course, coursekey:"key1")
        @course2 = FactoryGirl.create(:course, coursekey:"key2")
        @exercise1 = Exercise.create(course_id: @course1.id, html_id:"id1")  
        @exercise2 = Exercise.create(course_id: @course1.id, html_id:"id2")
        @exercise3 = Exercise.create(course_id: @course2.id, html_id:"id1")  
        @opiskelija1 = FactoryGirl.create(:user, username:"o1", first_name:"James", last_name:"Bond", email:"o1@o.o")
        @opiskelija2 = FactoryGirl.create(:user, username:"o2", first_name:"Bruce", last_name:"Wayne", email:"o2@o.o")
        Attendance.create(user_id: @opiskelija1.id, course_id: @course1.id)
        Attendance.create(user_id: @opiskelija1.id, course_id: @course2.id)
        @checkmark1 = Checkmark.create(user_id: @opiskelija1.id, exercise_id: @exercise1.id, status:"green")
        @checkmark2 = Checkmark.create(user_id: @opiskelija1.id, exercise_id: @exercise2.id, status:"red")
        @checkmark3 = Checkmark.create(user_id: @opiskelija1.id, exercise_id: @exercise3.id, status:"red")
      end
    
      it "cannot get scoreboards of other students" do
        sign_in @opiskelija1
        get 'student_scoreboard', :format => :json, params: {"sid": @opiskelija2.id,"cid":"1"}
        expect(response.status).to eq(401)
        get 'student_scoreboards', :format => :json, params: {"id": @opiskelija2.id}
        expect(response.status).to eq(401)
      end
      
      it "returns all scoreboards for student" do
        sign_in @opiskelija1
        get 'student_scoreboards', :format => :json, params: {"id":"1"}
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expect(body.size).to eq(2)
        expect(body[0]["coursekey"]).to eq(@course1.coursekey)
        expect(body[1]["coursekey"]).to eq(@course2.coursekey)
        expect(body[0]["exercises"].size).to eq(2)
        expect(body[1]["exercises"].size).to eq(1)
      end
      
      it "returns a scoreboard for student" do
        sign_in @opiskelija1
        get 'student_scoreboard', :format => :json, params: {"sid":@course1.id,"cid":@course1.id}
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expect(body.keys).to contain_exactly("name","coursekey","html_id","startdate","enddate","exercises")
        expect(body["exercises"][0].keys).to contain_exactly("id","status")
        expect(body["exercises"][0]["status"]).to eq(@checkmark1.status)
        expect(body["exercises"][0]["id"]).to eq(@exercise1.html_id)
        expect(body["exercises"][1]["status"]).to eq(@checkmark2.status)
        expect(body["exercises"][1]["id"]).to eq(@exercise2.html_id)
      end
      
    end
  end

  describe "get teacher scoreboard(s)" do
    context "when not logged in " do
      it "gives error message for scoreboard" do
        get 'scoreboard', :format => :json, params: {"id":"1"}
        expect(response.status).to eq(401)
      end
      it "gives error message for scoreboards" do
        get 'scoreboards', :format => :json, params: {"id":"1"}
        expect(response.status).to eq(401)
      end
    end
    
    context "when logged in" do
      before(:each) do
        @course1 = FactoryGirl.create(:course, coursekey:"key1")
        @course2 = FactoryGirl.create(:course, coursekey:"key2")
        @exercise1 = Exercise.create(course_id: @course1.id, html_id:"id1")  
        @exercise2 = Exercise.create(course_id: @course1.id, html_id:"id2")
        @opiskelija1 = FactoryGirl.create(:user, username:"o1", first_name:"James", last_name:"Bond", email:"o1@o.o")
        @opiskelija2 = FactoryGirl.create(:user, username:"o2", first_name:"Bruce", last_name:"Wayne", email:"o2@o.o")
        Attendance.create(user_id: @opiskelija1.id, course_id: @course1.id)
        Attendance.create(user_id: @opiskelija2.id, course_id: @course1.id)
        @checkmark1 = Checkmark.create(user_id: @opiskelija1.id, exercise_id: @exercise1.id, status:"green")
        @checkmark2 = Checkmark.create(user_id: @opiskelija1.id, exercise_id: @exercise2.id, status:"red")
        @checkmark3 = Checkmark.create(user_id: @opiskelija2.id, exercise_id: @exercise1.id, status:"red")
        @checkmark4 = Checkmark.create(user_id: @opiskelija2.id, exercise_id: @exercise2.id, status:"green")
        @ope1 = FactoryGirl.create(:user, username:"ope1", email:"ope1@o.o")
        Teaching.create(user_id: @ope1.id, course_id: @course1.id)
        Teaching.create(user_id: @ope1.id, course_id: @course2.id)
      end
    
      it "have to be teacher" do
        sign_in @opiskelija1
        get 'scoreboard', :format => :json, params: {"id":@course1.id}
        expect(response.status).to eq(401)
        get 'scoreboards', :format => :json, params: {"id":"1"}
        expect(response.status).to eq(401)
      end
      
      it "have to be teacher of the course" do
        @course3 = FactoryGirl.create(:course, coursekey:"key3")
        @ope2 = FactoryGirl.create(:user, username:"ope2", email:"ope2@o.o")
        Teaching.create(user_id: @ope2.id, course_id: @course3.id)
        sign_in @ope2
        get 'scoreboard', :format => :json, params: {"id":@course1.id}
        expect(response.status).to eq(401)
      end
      
      it "returns all scoreboards for teacher" do
        sign_in @ope1
        get 'scoreboards', :format => :json, params: {"id":"1"}
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expect(body.size).to eq(2)
        expect(body[0]["coursekey"]).to eq(@course1.coursekey)
        expect(body[1]["coursekey"]).to eq(@course2.coursekey)
      end
      
      it "returns a scoreboard for teacher" do
        sign_in @ope1
        get 'scoreboard', :format => :json, params: {"id":@course1.id}
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expect(body.keys).to contain_exactly("name","coursekey","html_id","startdate","enddate","students")
        expect(body["students"][0].keys).to contain_exactly("user","exercises")
        expect(body["students"][0]["exercises"][0].keys).to contain_exactly("id","status")
        expect(body["students"][0]["user"]).to eq("Bond James")
        expect(body["students"][1]["user"]).to eq("Wayne Bruce")
        expect(body["students"][0]["exercises"].size).to eq(2)
        expect(body["students"][0]["exercises"][0]["status"]).to eq(@checkmark1.status)
        expect(body["students"][0]["exercises"][0]["id"]).to eq(@exercise1.html_id)
        expect(body["students"][0]["exercises"][1]["status"]).to eq(@checkmark2.status)
        expect(body["students"][0]["exercises"][1]["id"]).to eq(@exercise2.html_id)
        expect(body["students"][1]["exercises"][0]["status"]).to eq(@checkmark3.status)
        expect(body["students"][1]["exercises"][0]["id"]).to eq(@exercise1.html_id)
        expect(body["students"][1]["exercises"][1]["status"]).to eq(@checkmark4.status)
        expect(body["students"][1]["exercises"][1]["id"]).to eq(@exercise2.html_id)
      end
      
      it "students with no names stored in database are nimettömiä" do
        @opiskelija3 = FactoryGirl.create(:user, username:"o1", first_name: nil, last_name: nil, email:"p1@o.o")
        @opiskelija4 = FactoryGirl.create(:user, username:"o2", first_name: nil, last_name: nil, email:"p2@o.o")
        Attendance.create(user_id: @opiskelija3.id, course_id: @course1.id)
        Attendance.create(user_id: @opiskelija4.id, course_id: @course1.id)
        Checkmark.create(user_id: @opiskelija3.id, exercise_id: @exercise1.id, status:"green")
        Checkmark.create(user_id: @opiskelija3.id, exercise_id: @exercise2.id, status:"red")
        Checkmark.create(user_id: @opiskelija4.id, exercise_id: @exercise1.id, status:"red")
        Checkmark.create(user_id: @opiskelija4.id, exercise_id: @exercise2.id, status:"green")
        sign_in @ope1
        get 'scoreboard', :format => :json, params: {"id":@course1.id}
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expect(body["students"].size).to eq(4)
        expect(body["students"][0]["user"]).to eq("Bond James")
        expect(body["students"][1]["user"]).to eq("Wayne Bruce")
        expect(body["students"][2]["user"]).to eq("Nimetön 1")
        expect(body["students"][3]["user"]).to eq("Nimetön 2")
      end
      
      it "user with last name only is shown correctly" do
        @opiskelija2.first_name = nil
        @opiskelija2.last_name = "Bond"
        @opiskelija2.save
        sign_in @ope1
        get 'scoreboard', :format => :json, params: {"id":@course1.id}
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expect(body["students"][0]["user"]).to eq("Bond James")
        expect(body["students"][1]["user"]).to eq("Bond")
      end
      
      it "user with first name only is shown correctly" do
        @opiskelija2.first_name = "James"
        @opiskelija2.last_name = nil
        @opiskelija2.save
        sign_in @ope1
        get 'scoreboard', :format => :json, params: {"id":@course1.id}
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expect(body["students"][0]["user"]).to eq("Bond James")
        expect(body["students"][1]["user"]).to eq("James")
      end
      
      
    end
  end




end
