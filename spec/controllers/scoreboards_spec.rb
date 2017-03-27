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
        @exercise1 = ExerciseService.create_exercise(@course1.id, "id1")
        @exercise2 = ExerciseService.create_exercise(@course1.id, "id2")
        @exercise3 = ExerciseService.create_exercise(@course2.id, "id1")
        @opiskelija1 = FactoryGirl.create(:user, username:"o1", first_name:"James", last_name:"Bond", email:"o1@o.o")
        @opiskelija2 = FactoryGirl.create(:user, username:"o2", first_name:"Bruce", last_name:"Wayne", email:"o2@o.o")
        AttendanceService.create_attendance(@opiskelija1.id, @course1.id)
        AttendanceService.create_attendance(@opiskelija1.id, @course2.id)
        CheckmarkService.save_student_checkmark(@opiskelija1.id, @exercise1.course_id, @exercise1.html_id, "green")
        CheckmarkService.save_student_checkmark(@opiskelija1.id, @exercise2.course_id, @exercise2.html_id, "red")
        CheckmarkService.save_student_checkmark(@opiskelija1.id, @exercise3.course_id, @exercise3.html_id, "red")
      end
    
      it "cannot get scoreboards of other students" do
        sign_in @opiskelija1
        get 'student_scoreboard', :format => :json, params: {"sid": @opiskelija2.id,"cid":@course1.id}
        expect(response.status).to eq(401)
        get 'student_scoreboards', :format => :json, params: {"id": @opiskelija2.id}
        expect(response.status).to eq(401)
      end
      
      it "returns all scoreboards for student" do
        sign_in @opiskelija1
        get 'student_scoreboards', :format => :json, params: {"id":@opiskelija1}
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
        get 'student_scoreboard', :format => :json, params: {"sid":@opiskelija1.id,"cid":@course1.id}
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expect(body.keys).to contain_exactly("name","coursekey","id", "html_id","startdate","enddate","exercises")
        expect(body["exercises"][0].keys).to contain_exactly("id","status")
        expect(body["exercises"][0]["status"]).to eq("green")
        expect(body["exercises"][0]["id"]).to eq(@exercise1.html_id)
        expect(body["exercises"][1]["status"]).to eq("red")
        expect(body["exercises"][1]["id"]).to eq(@exercise2.html_id)
      end
      
      it "doesnt return scoreboard if not on course" do
        @opiskelija3 = FactoryGirl.create(:user, username:"o1", first_name:"James", last_name:"Bond", email:"o5@o.o")
        sign_in @opiskelija3
        get 'student_scoreboard', :format => :json, params: {"sid":@opiskelija3.id,"cid":@course1.id}
        expect(response.status).to eq(422)
        body = JSON.parse(response.body)
        expected = {"error" => "Et ole liittynyt kyseiselle kurssille."}
        expect(body).to eq(expected)
      end
      
      it "shows exercises that are not done" do
        @exercise5 = ExerciseService.create_exercise(@course1.id, "id5")
        sign_in @opiskelija1
        get 'student_scoreboard', :format => :json, params: {"sid":@opiskelija1,"cid":@course1.id}
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expect(body["exercises"].size).to eq(3)
        expect(body["exercises"][2]["status"]).to eq("gray")
        expect(body["exercises"][2]["id"]).to eq(@exercise5.html_id)
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
        @exercise1 = ExerciseService.create_exercise(@course1.id, "id1")
        @exercise2 = ExerciseService.create_exercise(@course1.id, "id2")
        @opiskelija1 = FactoryGirl.create(:user, username:"o1", first_name:"James", last_name:"Bond", email:"o1@o.o")
        @opiskelija2 = FactoryGirl.create(:user, username:"o2", first_name:"Bruce", last_name:"Wayne", email:"o2@o.o")
        AttendanceService.create_attendance(@opiskelija1.id, @course1.id)
        AttendanceService.create_attendance(@opiskelija2.id, @course1.id)
        CheckmarkService.save_student_checkmark(@opiskelija1.id, @exercise1.course_id, @exercise1.html_id, "green")
        CheckmarkService.save_student_checkmark(@opiskelija1.id, @exercise2.course_id, @exercise2.html_id, "red")
        CheckmarkService.save_student_checkmark(@opiskelija2.id, @exercise1.course_id, @exercise1.html_id, "red")
        CheckmarkService.save_student_checkmark(@opiskelija2.id, @exercise2.course_id, @exercise2.html_id, "green")
        @ope1 = FactoryGirl.create(:user, username:"ope1", email:"ope1@o.o")
        TeachingService.create_teaching(@ope1.id, @course1.id)
        TeachingService.create_teaching(@ope1.id, @course2.id)
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
        TeachingService.create_teaching(@ope2.id, @course3.id)
        sign_in @ope2
        get 'scoreboard', :format => :json, params: {"id":@course1.id}
        expect(response.status).to eq(401)
      end
      
      it "returns all scoreboards for teacher" do
        sign_in @ope1
        get 'scoreboards', :format => :json, params: {"id":@ope1.id}
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
        expect(body.keys).to contain_exactly("name","coursekey","id", "html_id","startdate","enddate","students")
        expect(body["students"][0].keys).to contain_exactly("user","exercises")
        expect(body["students"][0]["exercises"][0].keys).to contain_exactly("id","status")
        expect(body["students"][0]["user"]).to eq("Bond James")
        expect(body["students"][1]["user"]).to eq("Wayne Bruce")
        expect(body["students"][0]["exercises"].size).to eq(2)
        expect(body["students"][0]["exercises"][0]["status"]).to eq("green")
        expect(body["students"][0]["exercises"][0]["id"]).to eq(@exercise1.html_id)
        expect(body["students"][0]["exercises"][1]["status"]).to eq("red")
        expect(body["students"][0]["exercises"][1]["id"]).to eq(@exercise2.html_id)
        expect(body["students"][1]["exercises"][0]["status"]).to eq("red")
        expect(body["students"][1]["exercises"][0]["id"]).to eq(@exercise1.html_id)
        expect(body["students"][1]["exercises"][1]["status"]).to eq("green")
        expect(body["students"][1]["exercises"][1]["id"]).to eq(@exercise2.html_id)
      end
      
      it "shows exercises that student is not done" do
        @exercise3 = ExerciseService.create_exercise(@course1.id, "id3")
        sign_in @ope1
        get 'scoreboard', :format => :json, params: {"id":@course1.id}
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expect(body["students"][0]["exercises"].size).to eq(3)
        expect(body["students"][0]["exercises"][2]["status"]).to eq("gray")
        expect(body["students"][0]["exercises"][2]["id"]).to eq(@exercise3.html_id)
      end
      
      it "students with no names stored in database are nimettömiä" do
        @opiskelija3 = FactoryGirl.create(:user, username:"o1", first_name: nil, last_name: nil, email:"p1@o.o")
        @opiskelija4 = FactoryGirl.create(:user, username:"o2", first_name: nil, last_name: nil, email:"p2@o.o")
        AttendanceService.create_attendance(@opiskelija3.id, @course1.id)
        AttendanceService.create_attendance(@opiskelija4.id, @course1.id)
        CheckmarkService.save_student_checkmark(@opiskelija3.id, @exercise1.course_id, @exercise1.html_id, "green")
        CheckmarkService.save_student_checkmark(@opiskelija3.id, @exercise2.course_id, @exercise2.html_id, "red")
        CheckmarkService.save_student_checkmark(@opiskelija4.id, @exercise1.course_id, @exercise1.html_id, "red")
        CheckmarkService.save_student_checkmark(@opiskelija4.id, @exercise2.course_id, @exercise2.html_id, "green")
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
