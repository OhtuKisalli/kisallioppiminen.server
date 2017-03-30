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
end
