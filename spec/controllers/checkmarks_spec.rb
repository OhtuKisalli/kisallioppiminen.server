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
        @exercise = Exercise.create(course_id: @course.id, html_id:"id2")
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
        Attendance.create(user_id: @testaaja.id, course_id: @course.id)
        @course2 = FactoryGirl.create(:course, coursekey:"key3")
        @exercise2 = Exercise.create(course_id: @course2.id, html_id:"id3")
        post 'mark', :format => :json, params: {"html_id":@exercise2.html_id,"coursekey":@course.coursekey,"status":"green"}
        expect(response.status).to eq(403)
        expect(Checkmark.count).to eq(0)
      end
      it "creates new checkmark" do
        Attendance.create(user_id: @testaaja.id, course_id: @course.id)
        post 'mark', :format => :json, params: {"html_id":@exercise.html_id,"coursekey":@course.coursekey,"status":"green"}
        expect(response.status).to eq(201)
        expect(Checkmark.count).to eq(1)
      end
      it "checkmarking again updates old one" do
        Attendance.create(user_id: @testaaja.id, course_id: @course.id)
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


end

