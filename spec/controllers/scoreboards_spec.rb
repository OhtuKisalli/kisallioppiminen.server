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





end
