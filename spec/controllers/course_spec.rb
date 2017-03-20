require 'rails_helper'
require 'date'

RSpec.describe CoursesController, type: :controller do

  let(:valid_attributes) { {html_id: "exampleHtmlId", coursekey:"examplekey", name:"matikka1"} }


  let(:invalid_attributes) { {name:321}  }

  let(:valid_session) { {} }
  
  describe "Teacher – I can see a listing of my courses" do
  
    context "when not logged in " do
      it "gives error message" do
        get 'mycourses_teacher', :format => :json, params: {"id":1}
        expect(response.status).to eq(401)
      end
    end
        
    context "when logged in" do
      before(:each) do
        @course1 = FactoryGirl.create(:course)
        @course2 = FactoryGirl.create(:course, coursekey:"key2")
        @testaaja = FactoryGirl.create(:user)
        sign_in @testaaja
      end
      it "returns empty json when no courses" do
        get 'mycourses_teacher', :format => :json, params: {"id":@testaaja.id}
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expected = []
        expect(body).to eq(expected)
      end
      it "returns a course where user is teacher" do
        TeachingService.create_teaching(@testaaja.id, @course1.id)
        get 'mycourses_teacher', :format => :json, params: {"id":@testaaja.id}
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expect(body.size).to eq(1)
        expect(body[0].keys).to contain_exactly("name","coursekey","id", "html_id","startdate","enddate","archived")
        expect(body[0]["coursekey"]).to eq(@course1.coursekey)
      end
      it "return all courses where user is teacher" do
        TeachingService.create_teaching(@testaaja.id, @course1.id)
        TeachingService.create_teaching(@testaaja.id, @course2.id)
        get 'mycourses_teacher', :format => :json, params: {"id":@testaaja.id}
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expect(body.size).to eq(2)
      end
    end
  end
  
  #
  describe "Courses for student" do
  
    context "when not logged in " do
      it "gives error message" do
        get 'mycourses_student', :format => :json, params: {"id":1}
        expect(response.status).to eq(401)
      end
    end
        
    context "when logged in" do
      before(:each) do
        @course1 = FactoryGirl.create(:course)
        @course2 = FactoryGirl.create(:course, coursekey:"key2")
        @testaaja = FactoryGirl.create(:user)
        sign_in @testaaja
      end
      it "returns empty json when no courses" do
        get 'mycourses_student', :format => :json, params: {"id":@testaaja.id}
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expect(body.size).to eq(0)
      end
      it "returns only own courses" do
        @opiskelija2 = FactoryGirl.create(:user, username:"o2", name:"bruce", email:"o2@o.o")
        AttendanceService.create_attendance(@opiskelija2.id, @course1.id)
        AttendanceService.create_attendance(@testaaja.id, @course1.id)
        get 'mycourses_student', :format => :json, params: {"id":@opiskelija2.id}
        expect(response.status).to eq(401)
        body = JSON.parse(response.body)
        expected = {"error" => "Voit hakea vain omat kurssisi."}
        expect(body).to eq(expected)
      end
      
      it "returns a course where user is student" do
        AttendanceService.create_attendance(@testaaja.id, @course1.id)
        get 'mycourses_student', :format => :json, params: {"id":@testaaja.id}
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expect(body.size).to eq(1)
        expect(body[0]["coursekey"]).to eq(@course1.coursekey)
      end
      it "return all courses where user is student" do
        AttendanceService.create_attendance(@testaaja.id, @course1.id)
        AttendanceService.create_attendance(@testaaja.id, @course2.id)
        get 'mycourses_student', :format => :json, params: {"id":@testaaja.id}
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expect(body.size).to eq(2)
        expect(body[0]["coursekey"]).to eq(@course1.coursekey)
        expect(body[1]["coursekey"]).to eq(@course2.coursekey)
      end
    end
  end
  
  #
  describe "Teacher – I can create coursekeys for students to join my course" do
    context "when not logged in" do
      it "gives error message" do
        post 'newcourse', :format => :json, params: {"coursekey":"avain1", "name":"kurssi", "exercises": {"0.1": "23b6f818-3def-4c40-a794-6d5a9c45a0ff", "0.2": "ff50db85-f7a9-4c03-8faf-9a17d932b435","1.1": "0d7c9d8e-9c84-44fb-b5a7-33becc01af14"}}
        expect(response.status).to eq(401)
      end
    end
    
    context "when logged in" do
      before(:each) do
        @course2 = FactoryGirl.create(:course, coursekey:"key2")
        @testaaja = FactoryGirl.create(:user)
        sign_in @testaaja
      end
    
      it "doesn't allow to use reserved coursekey" do
        post 'newcourse', :format => :json, params: {"coursekey":"key2", "name":"kurssi", "exercises": {"0.1": "23b6f818-3def-4c40-a794-6d5a9c45a0ff", "0.2": "ff50db85-f7a9-4c03-8faf-9a17d932b435","1.1": "0d7c9d8e-9c84-44fb-b5a7-33becc01af14"}}
        expect(response.status).to eq(403)
        expect(Course.all.count).to eq(1)
      end
      
      it "creates course but warns if no exercises selected" do
        post 'newcourse', :format => :json, params: {"coursekey":"avain1", "name":"kurssi"}
        expect(response.status).to eq(202)
        expect(Course.all.count).to eq(2)
      end
      
      it "adds teacher to created course" do
        expect(TeachingService.all_teachings.count).to eq(0)
        post 'newcourse', :format => :json, params: {"coursekey":"avain1", "name":"kurssi"}
        expect(TeachingService.all_teachings.count).to eq(1)
        expect(TeachingService.is_teacher?(@testaaja.id)).to eq(true)
        expect(UserService.teacher_courses(@testaaja.id).first.coursekey).to eq("avain1")
      end
      
      it "created course is not archived" do
        post 'newcourse', :format => :json, params: {"coursekey":"avain1", "name":"kurssi"}
        @c = CourseService.find_by_coursekey("avain1")
        expect(TeachingService.is_archived?(@testaaja.id, @c.id)).to eq(false)
      end
      
      it "creates course with exercises" do
        expect(ExerciseService.all_exercises.count).to eq(0)
        post 'newcourse', :format => :json, params: {"coursekey":"avain1", "name":"kurssi", "exercises": {"0.1": "23b6f818-3def-4c40-a794-6d5a9c45a0ff", "0.2": "ff50db85-f7a9-4c03-8faf-9a17d932b435","1.1": "0d7c9d8e-9c84-44fb-b5a7-33becc01af14"}}
        expect(response.status).to eq(200)
        expect(Course.find_by(coursekey:"avain1").exercises.count).to eq(3)
      end
    end
  end
  
  
  describe "updating course" do
    context "when not logged in " do
      it "gives error message" do
        put 'update', :format => :json, params: {"id":1}
        expect(response.status).to eq(401)
        body = JSON.parse(response.body)
        expected = {"error" => "Sinun täytyy ensin kirjautua sisään."}
        expect(body).to eq(expected)
      end
    end
        
    context "when logged in" do
      before(:each) do
        @course1 = FactoryGirl.create(:course, coursekey:"key1")
        @testaaja = FactoryGirl.create(:user)
        sign_in @testaaja
      end
      it "only if teacher of the course" do
        put 'update', :format => :json, params: {"id":@course1.id}
        expect(response.status).to eq(401)
        body = JSON.parse(response.body)
        expected = {"error" => "Et ole kyseisen kurssin opettaja."}
        expect(body).to eq(expected)
      end
      it "coursekey must not be reserved" do
        TeachingService.create_teaching(@testaaja.id, @course1.id)
        FactoryGirl.create(:course, coursekey:"varattu")
        put 'update', :format => :json, params: {"id":@course1.id, "coursekey": "varattu"}
        expect(response.status).to eq(403)
        body = JSON.parse(response.body)
        expected = {"error" => "Kurssiavain on jo varattu."}
        expect(body).to eq(expected)
        expect(Course.find(@course1.id).coursekey).to eq("key1")
      end
      it "updates course with proper values" do
        Teaching.create(user_id: @testaaja.id, course_id: @course1.id)
        expect(@course1.coursekey).not_to eq("uusi")
        expect(@course1.name).not_to eq("uusinimi")
        expect(@course1.startdate).not_to eq(Date.parse("2017-06-01"))
        expect(@course1.enddate).not_to eq(Date.parse("2017-06-02"))
        put 'update', :format => :json, params: {"id":@course1.id, "coursekey": "uusi", "name": "uusinimi", "startdate": "2017-06-01", "enddate": "2017-06-02"}
        expect(response.status).to eq(200)
        c = Course.find(@course1.id)
        expect(c.coursekey).to eq("uusi")
        expect(c.name).to eq("uusinimi")
        expect(c.startdate).to eq(Date.parse("2017-06-01"))
        expect(c.enddate).to eq(Date.parse("2017-06-02"))
      end
    end
  end
    
end
