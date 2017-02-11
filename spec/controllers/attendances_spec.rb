require 'rails_helper'

RSpec.describe AttendancesController, type: :controller do

  describe "Student – I can join a specific course using a coursekeys" do
    context "when not logged in" do
      it "gives error message" do
        post 'newstudent', :format => :json, params: {"coursekey": "maa1s2031"}
        expect(response.status).to eq(401)
      end
    end
    
    context "when logged in" do
      before(:each) do
        @course1 = FactoryGirl.create(:course)
        @testaaja = FactoryGirl.create(:user)
        sign_in @testaaja
      end
      it "doesn't allow to join uncreated course" do
        post 'newstudent', :format => :json, params: {"coursekey": "maa1s2031"}
        expect(response.status).to eq(204)
        expect(@testaaja.courses).to be_empty
      end
      it "allows to join a new course once" do
        post 'newstudent', :format => :json, params: {"coursekey": @course1.coursekey}
        expect(response.status).to eq(200)
        expect(@testaaja.courses.count).to eq(1)
      end
      it "doesn't allow to join same course again'" do
        Attendance.create(user_id: @testaaja.id, course_id: @course1.id)
        post 'newstudent', :format => :json, params: {"coursekey": @course1.coursekey}
        expect(response.status).to eq(403)
        expect(@testaaja.courses.count).to eq(1)
      end
    end
  
  end

end
