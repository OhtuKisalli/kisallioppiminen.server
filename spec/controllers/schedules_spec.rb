require 'rails_helper'

RSpec.describe SchedulesController, type: :controller do
  
  describe "Teacher – Add new schedule to schedulelist" do
  
    context "when not logged in" do
      it "gives error message" do
        post 'new_schedule', :format => :json, params: {"id":1, "name":"nimi"}
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
      it "name necessary" do
        post 'new_schedule', :format => :json, params: {"id": @course.id}
        expect(response.status).to eq(422)
        body = JSON.parse(response.body)
        expected = {"error" => "Tavoitteella täytyy olla nimi."}
        expect(body).to eq(expected)
      end
      it "name must be uniq" do
        ScheduleService.add_new_schedule(@course.id, "reserved")
        post 'new_schedule', :format => :json, params: {"id": @course.id, "name": "reserved"}
        expect(response.status).to eq(422)
        body = JSON.parse(response.body)
        expected = {"error" => "Kahdella tavoitteella ei voi olla samaa nimeä."}
        expect(body).to eq(expected)
      end
    end
        
    context "with proper params" do
      before(:each) do
        @course = FactoryGirl.create(:course, coursekey:"key1")
        @course2 = FactoryGirl.create(:course, coursekey:"key2")
        @ope = FactoryGirl.create(:user, username:"ope1", email:"ope1@o.o")
        @ope2 = FactoryGirl.create(:user, username:"ope2", email:"ope2@o.o")
        TeachingService.create_teaching(@ope.id, @course.id)
        TeachingService.create_teaching(@ope2.id, @course2.id)
      end
      it "must be teacher on the course" do
        sign_in @ope2
        post 'new_schedule', :format => :json, params: {"id": @course.id, "name": "name2"}
        expect(response.status).to eq(401)
        body = JSON.parse(response.body)
        expected = {"error" => "Et ole kyseisen kurssin vastuuhenkilö."}
        expect(body).to eq(expected)
      end
      it "adds schedule correctly" do
        sign_in @ope
        post 'new_schedule', :format => :json, params: {"id": @course.id, "name": "name1"}
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expected = {"message" => "Tavoite tallennettu tietokantaan."}
        expect(body).to eq(expected)
        schedule = ScheduleService.all_schedules.first
        expect(schedule.name).to eq("name1")
        expect(schedule.course_id).to eq(@course.id)
        expect(schedule.exercises).to eq([])
      end
    end
  end

  describe "Teacher – delete schedule" do
    context "without rights" do
      it "gives error message when not logged in" do
        delete 'delete_schedule', :format => :json, params: {"cid" => 1, "did" => 1}
        expect(response.status).to eq(401)
        body = JSON.parse(response.body)
        expected = {"error" => "Sinun täytyy ensin kirjautua sisään."}
        expect(body).to eq(expected)
      end
      it "gives error message if not teacher of course" do
        FactoryGirl.create(:course, coursekey:"key1")
        @ope = FactoryGirl.create(:user, username:"ope1", email:"ope1@o.o")
        sign_in @ope
        delete 'delete_schedule', :format => :json, params: {"cid" => 1, "did" => 1}
        expect(response.status).to eq(401)
        body = JSON.parse(response.body)
        expected = {"error" => "Et ole kyseisen kurssin vastuuhenkilö."}
        expect(body).to eq(expected)
      end
    end
    context "with rights" do
      before(:each) do
        @course = FactoryGirl.create(:course, coursekey:"key1")
        @ope = FactoryGirl.create(:user, username:"ope1", email:"ope1@o.o")
        TeachingService.create_teaching(@ope.id, @course.id)
        sign_in @ope
      end
      
      it "deletes deadline" do
        ScheduleService.add_new_schedule(@course.id, "nimi")
        delete 'delete_schedule', :format => :json, params: {"cid": @course.id, "did": ScheduleService.all_schedules.first.id}
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expected = {"message" => "Tavoite poistettu."}
        expect(body).to eq(expected)
        expect(ScheduleService.all_schedules.count).to eq(0)
      end
      it "doesnt delete schedule that not on course" do
        @course2 = FactoryGirl.create(:course, coursekey:"key2")
        ScheduleService.add_new_schedule(@course2.id, "nimi")
        delete 'delete_schedule', :format => :json, params: {"cid": @course.id, "did": ScheduleService.all_schedules.first.id}
        expect(response.status).to eq(401)
        body = JSON.parse(response.body)
        expected = {"error" => "Kyseinen tavoite ei ole kurssilla."}
        expect(body).to eq(expected)
      end
    end
  end
  
  describe "Teacher – I can create schedule for course" do
  
    context "when not logged in" do
      it "gives error message" do
        post 'update_exercises', :format => :json, params: {"id":1}
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
        TeachingService.create_teaching(@ope.id, @course.id)
        sign_in @ope
      end
      it "schedules necessary" do
        post 'update_exercises', :format => :json, params: {"id": @course.id}
        expect(response.status).to eq(422)
        body = JSON.parse(response.body)
        expected = {"error" => "Parametri schedules on virheellinen."}
        expect(body).to eq(expected)
      end
                 
    end
        
    context "with proper params" do
      before(:each) do
        @course = FactoryGirl.create(:course, coursekey:"key1")
        @ope = FactoryGirl.create(:user, username:"ope1", email:"ope1@o.o")
        TeachingService.create_teaching(@ope.id, @course.id)
        @schedule = Schedule.create(name: "nimi", course_id: @course.id, exercises: [])
        sign_in @ope
      end
      it "must be teacher of the course" do
        @ope2 = FactoryGirl.create(:user, username:"ope21", email:"ope21@o.o")
        sign_in @ope2
        post 'update_exercises', :format => :json, params: {"id": @course.id,"schedules": {"id1": true}}
        expect(response.status).to eq(401)
        body = JSON.parse(response.body)
        expected = {"error" => "Et ole kyseisen kurssin vastuuhenkilö."}
        expect(body).to eq(expected)
      end
      it "saves schedule correctly" do
        sign_in @ope
        @schedule2 = Schedule.create(name: "nimi2", course_id: @course.id, exercises: [])
        @schedule3 = Schedule.create(name: "nimi3", course_id: @course.id, exercises: ["id1"])
        @schedule4 = Schedule.create(name: "nimi4", course_id: @course.id, exercises: ["id2"])
        hash = {}
        hash[@schedule.id.to_s] = {"id1" => true, "id2" => true}
        hash[@schedule2.id.to_s] = {"id1" => false}
        hash[@schedule3.id.to_s] = {"id1" => true}
        hash[@schedule4.id.to_s] = {"id2" => false}
        #post 'update_exercises', :format => :json, params: {"id": @course.id, "schedules": hash}
        post 'update_exercises', params: {"id": @course.id, "schedules": hash}, as: :json
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expected = {"message" => "Tavoitteet tallennettu tietokantaan."}
        expect(body).to eq(expected)
        s1 = Schedule.where(id: @schedule.id).first
        s2 = Schedule.where(id: @schedule2.id).first
        s3 = Schedule.where(id: @schedule3.id).first
        s4 = Schedule.where(id: @schedule4.id).first
        expect(s1.exercises.include? "id1").to eq(true)
        expect(s1.exercises.include? "id2").to eq(true)
        expect(s2.exercises.include? "id1").to eq(false)
        expect(s3.exercises.include? "id1").to eq(true)
        expect(s4.exercises.include? "id2").to eq(false)
        expect(s1.exercises.size).to eq(2)
        expect(s2.exercises.size).to eq(0)
        expect(s3.exercises.size).to eq(1)
        expect(s4.exercises.size).to eq(0)
      end
    end
  end
  
  describe "User – get_schedules" do
    context "without rights" do
      it "gives error message when not logged in" do
        get 'get_schedules', :format => :json, params: {"id": 666}
        expect(response.status).to eq(401)
        body = JSON.parse(response.body)
        expected = {"error" => "Sinun täytyy ensin kirjautua sisään."}
        expect(body).to eq(expected)
      end
      it "gives error message if not teacher or student course" do
        @course = FactoryGirl.create(:course, coursekey:"key1")
        @ope = FactoryGirl.create(:user, username:"ope1", email:"ope1@o.o")
        sign_in @ope
        get 'get_schedules', :format => :json, params: {"id": @course.id}
        expect(response.status).to eq(401)
        body = JSON.parse(response.body)
        expected = {"error" => "Et ole kyseisen kurssin oppilas tai opettaja."}
        expect(body).to eq(expected)
      end
    end
    context "with rights" do
      before(:each) do
        @course = FactoryGirl.create(:course, coursekey:"key1")
        @ope = FactoryGirl.create(:user, username:"ope1", email:"ope1@o.o")
        TeachingService.create_teaching(@ope.id, @course.id)
      end
      it "gives schedules to teacher" do
        sign_in @ope
        get 'get_schedules', :format => :json, params: {"id": @course.id}
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expect(body).to eq([])
      end
      it "gives schedules to student" do
        @opiskelija1 = FactoryGirl.create(:user, username:"o1", first_name:"James", last_name:"Bond", email:"o1@o.o")
        AttendanceService.create_attendance(@opiskelija1.id, @course.id)
        sign_in @opiskelija1
        get 'get_schedules', :format => :json, params: {"id": @course.id}
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expect(body).to eq([])
      end
      it "gives schedules" do
        s1 = Schedule.create(name: "nimi", course_id: @course.id, exercises: [])
        s2 = Schedule.create(name: "nimi2", course_id: @course.id, exercises: ["aaa","bbb"])
        sign_in @ope
        get 'get_schedules', :format => :json, params: {"id": @course.id}
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expect(body.size).to eq(2)
        expect(body[0].keys).to contain_exactly("id","name","exercises")
        expect(body[0]["id"]).to eq(s1.id)
        expect(body[0]["name"]).to eq(s1.name)
        expect(body[0]["exercises"]).to eq(s1.exercises)
        expect(body[1].keys).to contain_exactly("id","name","exercises")
        expect(body[1]["id"]).to eq(s2.id)
        expect(body[1]["name"]).to eq(s2.name)
        expect(body[1]["exercises"]).to eq(s2.exercises)
      end
    end
  end
  
  
end
