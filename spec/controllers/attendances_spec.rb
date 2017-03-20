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
        expect(response.status).to eq(403)
        body = JSON.parse(response.body)
        expected = {"error" => "Kurssia ei löydy tietokannasta."}
        expect(body).to eq(expected)
        expect(@testaaja.courses).to be_empty
      end
      it "allows to join a new course once" do
        post 'newstudent', :format => :json, params: {"coursekey": @course1.coursekey}
        expect(response.status).to eq(200)
        expect(@testaaja.courses.count).to eq(1)
        body = JSON.parse(response.body)
        expect(body.length).to eq(2)
        expect(body.keys).to contain_exactly("message","courses")
      end
      it "doesn't allow to join same course again'" do
        AttendanceService.create_attendance(@testaaja.id, @course1.id)
        post 'newstudent', :format => :json, params: {"coursekey": @course1.coursekey}
        expect(response.status).to eq(403)
        body = JSON.parse(response.body)
        expected = {"error" => "Olet jo liittynyt kyseiselle kurssille."}
        expect(body).to eq(expected)
        expect(@testaaja.courses.count).to eq(1)
      end
      it "allows to join more than one course" do
        @course2 = FactoryGirl.create(:course, coursekey: "avain2")
        post 'newstudent', :format => :json, params: {"coursekey": @course1.coursekey}
        post 'newstudent', :format => :json, params: {"coursekey": @course2.coursekey}
        expect(@testaaja.courses.count).to eq(2)
      end
      it "new course is not archived" do
        post 'newstudent', :format => :json, params: {"coursekey": @course1.coursekey}
        expect(AttendanceService.student_course_archived?(@testaaja.id, @course1.id)).to eq(false)
      end
    end
  end
  
  describe "student toggling archived of courses" do
  
    context "when not logged in" do
      it "gives error message" do
        post 'toggle_archived', :format => :json, params: {"sid":1,"cid":1,"archived": "true"}
        expect(response.status).to eq(401)
        body = JSON.parse(response.body)
        expected = {"error" => "Sinun täytyy ensin kirjautua sisään."}
        expect(body).to eq(expected)
      end
    end
    
    context "when logged in" do
      before(:each) do
        @course1 = FactoryGirl.create(:course)
        @testaaja = FactoryGirl.create(:user)
        sign_in @testaaja
      end
      it "can only toggle archived of own courses" do
        post 'toggle_archived', :format => :json, params: {"sid":2,"cid":1,"archived": "true"}
        expect(response.status).to eq(401)
        body = JSON.parse(response.body)
        expected = {"error" => "Voit muuttaa vain omien kurssiesi asetuksia."}
        expect(body).to eq(expected)
      end
      it "cannot toggle archived if not on course" do
        post 'toggle_archived', :format => :json, params: {"sid":@testaaja.id,"cid":@course1.id,"archived": "true"}
        expect(response.status).to eq(403)
      end
      it "cannot toggle archived without parameter archived" do
        AttendanceService.create_attendance(@testaaja.id, @course1.id)
        post 'toggle_archived', :format => :json, params: {"sid":@testaaja.id,"cid":@course1.id,"aaa": "true"}
        expect(response.status).to eq(422)
      end
      it "cannot toggle archived with improper value" do
        AttendanceService.create_attendance(@testaaja.id, @course1.id)
        post 'toggle_archived', :format => :json, params: {"sid":@testaaja.id,"cid":@course1.id,"archived": "joo"}
        expect(response.status).to eq(422)
      end
      it "can toggle archived from false to true" do
        AttendanceService.create_attendance(@testaaja.id, @course1.id)
        post 'toggle_archived', :format => :json, params: {"sid":@testaaja.id,"cid":@course1.id,"archived": "true"}
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expected = {"message" => "Kurssi arkistoitu."}
        expect(body).to eq(expected)
        expect(AttendanceService.student_course_archived?(@testaaja.id, @course1.id)).to eq(true)
      end
      it "can toggle archived from true to false" do
        AttendanceService.create_attendance(@testaaja.id, @course1.id)
        AttendanceService.change_archived_status(@testaaja.id, @course1.id, "true")
        post 'toggle_archived', :format => :json, params: {"sid":@testaaja.id,"cid":@course1.id,"archived": "false"}
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expected = {"message" => "Kurssi palautettu arkistosta."}
        expect(body).to eq(expected)
        expect(AttendanceService.student_course_archived?(@testaaja.id, @course1.id)).to eq(false)
      end
      it "trying to archive archived course makes no changes" do
        AttendanceService.create_attendance(@testaaja.id, @course1.id)
        AttendanceService.change_archived_status(@testaaja.id, @course1.id, "true")
        post 'toggle_archived', :format => :json, params: {"sid":@testaaja.id,"cid":@course1.id,"archived": "true"}
        expect(AttendanceService.student_course_archived?(@testaaja.id, @course1.id)).to eq(true)
      end
      it "trying to recover course that is recovered makes on changes" do
        AttendanceService.create_attendance(@testaaja.id, @course1.id)
        post 'toggle_archived', :format => :json, params: {"sid":@testaaja.id,"cid":@course1.id,"archived": "false"}
        expect(AttendanceService.student_course_archived?(@testaaja.id, @course1.id)).to eq(false)
      end
    
    end
  
  
  end

end
