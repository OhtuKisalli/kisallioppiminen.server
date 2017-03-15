require 'rails_helper'

RSpec.describe CheckmarksController, type: :controller do

  describe "student checkmarking exercise" do
    context "when not logged in" do
      it "gives error message" do
        post 'mark', :format => :json
        expect(response.status).to eq(401)
      end
    end
    
    context "when logged in" do
      before(:each) do
        @course = FactoryGirl.create(:course, coursekey:"key2")
        @exercise = ExerciseService.create_exercise(@course.id, "id2")
        @testaaja = FactoryGirl.create(:user)
        sign_in @testaaja
      end
      it "cant checkmark exercise with incorrect coursekey" do
        post 'mark', :format => :json, params: {"html_id":@exercise.html_id,"coursekey":"perse","status":"green"}
        expect(response.status).to eq(403)
        expect(Checkmark.count).to eq(0)
      end
      it "cant checkmark exercise if not joined course" do
        post 'mark', :format => :json, params: {"html_id":@exercise.html_id,"coursekey":@course.coursekey,"status":"green"}
        expect(response.status).to eq(422)
        expect(Checkmark.count).to eq(0)
      end
      it "cant checkmark exercise that doesnt belong to course" do
        AttendanceService.create_attendance(@testaaja.id, @course.id)
        @course2 = FactoryGirl.create(:course, coursekey:"key3")
        @exercise2 = ExerciseService.create_exercise(@course2.id, "id3")
        post 'mark', :format => :json, params: {"html_id":@exercise2.html_id,"coursekey":@course.coursekey,"status":"green"}
        expect(response.status).to eq(403)
        expect(Checkmark.count).to eq(0)
      end
      it "creates new checkmark" do
        AttendanceService.create_attendance(@testaaja.id, @course.id)
        post 'mark', :format => :json, params: {"html_id":@exercise.html_id,"coursekey":@course.coursekey,"status":"green"}
        expect(response.status).to eq(201)
        expect(Checkmark.count).to eq(1)
      end
      it "checkmarking again updates old one" do
        AttendanceService.create_attendance(@testaaja.id, @course.id)
        post 'mark', :format => :json, params: {"html_id":@exercise.html_id,"coursekey":@course.coursekey,"status":"green"}
        expect(response.status).to eq(201)
        expect(Checkmark.count).to eq(1)
        expect(Checkmark.first.status).to eq("green")
        post 'mark', :format => :json, params: {"html_id":@exercise.html_id,"coursekey":@course.coursekey,"status":"red"}
        expect(Checkmark.count).to eq(1)
        expect(Checkmark.first.status).to eq("red")
      end
    end
  end
  
  describe "getting checkmarks" do
    context "when not logged in" do
      it "gives error message" do
        get 'student_checkmarks', :format => :json, params: {"sid":1,"cid":1}
        expect(response.status).to eq(401)
      end
    end
    
    context "when logged in" do
      before(:each) do
        @course = FactoryGirl.create(:course, coursekey:"key1")
        @exercise1 = ExerciseService.create_exercise(@course.id, "id1")
        @exercise2 = ExerciseService.create_exercise(@course.id, "id2")
        @opiskelija1 = FactoryGirl.create(:user, username:"o1", email:"o1@o.o")
        Attendance.create(user_id: @opiskelija1.id, course_id: @course.id)
        @checkmark1 = Checkmark.create(user_id: @opiskelija1.id, exercise_id: @exercise1.id, status:"green")
        @checkmark2 = Checkmark.create(user_id: @opiskelija1.id, exercise_id: @exercise2.id, status:"red")
        @opiskelija2 = FactoryGirl.create(:user, username:"o2", email:"o2@o.o")
        @ope = FactoryGirl.create(:user, username:"ope1", email:"ope1@o.o")
        TeachingService.create_teaching(@ope.id, @course.id)
      end
      it "can't see other student's checkmarks" do
        sign_in @opiskelija2
        get 'student_checkmarks', :format => :json, params: {"sid":@opiskelija1.id,"cid":@course.id}
        expect(response.status).to eq(401)
      end
      it "can see own checkmarks" do
        sign_in @opiskelija1
        get 'student_checkmarks', :format => :json, params: {"sid":@opiskelija1.id,"cid":@course.id}
        expect(response.status).not_to eq(401)
        body = JSON.parse(response.body)
        expect(body.keys).to contain_exactly("html_id","exercises","coursekey","archived")
        expect(body["exercises"][0]["status"]).to eq(@checkmark1.status)
        expect(body["exercises"][1]["status"]).to eq(@checkmark2.status)
      end
      it "can see checkmarks of own students when teacher" do
        sign_in @ope
        get 'student_checkmarks', :format => :json, params: {"sid":@opiskelija1.id,"cid":@course.id}
        expect(response.status).to eq(200)
      end
      
      it "can only see own checkmarks" do
        AttendanceService.create_attendance(@opiskelija2.id, @course.id)
        sign_in @opiskelija2
        get 'student_checkmarks', :format => :json, params: {"sid":@opiskelija2.id,"cid":@course.id}
        body = JSON.parse(response.body)
        expect(body["id1"]).to eq(nil)
      end
      
      it "no checkmarks if not joined course" do
        sign_in @opiskelija2
        get 'student_checkmarks', :format => :json, params: {"sid":@opiskelija2.id,"cid":@course.id}
        expect(response.status).to eq(422)
      end
    end
  end
end

