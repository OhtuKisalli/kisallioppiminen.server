require 'rails_helper'

RSpec.describe CoursesController, type: :controller do

  let(:valid_attributes) { {html_id: "exampleHtmlId", coursekey:"examplekey", name:"matikka1"} }


  let(:invalid_attributes) { {name:321}  }

  let(:valid_session) { {} }
  
  describe "Teacher – I can see a listing of my courses" do
  
    context "when not logged in " do
      it "gives error message" do
        get 'mycourses_teacher', :format => :json
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
        get 'mycourses_teacher', :format => :json
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expected = {}
        expect(body).to eq(expected)
      end
      it "returns a course where user is teacher" do
        Teaching.create(user_id: @testaaja.id, course_id: @course1.id)
        get 'mycourses_teacher', :format => :json
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expect(body.length).to eq(1)
        expect(body.keys).to contain_exactly(@course1.coursekey)
      end
      it "return all courses where user is teacher" do
        Teaching.create(user_id: @testaaja.id, course_id: @course1.id)
        Teaching.create(user_id: @testaaja.id, course_id: @course2.id)
        get 'mycourses_teacher', :format => :json
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expect(body.length).to eq(2)
        expect(body.keys).to contain_exactly(@course1.coursekey, @course2.coursekey)
      end
    end
  end
  
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
        expect(Teaching.all.count).to eq(0)
        post 'newcourse', :format => :json, params: {"coursekey":"avain1", "name":"kurssi"}
        expect(Teaching.all.count).to eq(1)
        expect(Teaching.first.id).to eq(@testaaja.id)
      end
      
      it "creates course with exercises" do
        expect(Exercise.all.count).to eq(0)
        post 'newcourse', :format => :json, params: {"coursekey":"avain1", "name":"kurssi", "exercises": {"0.1": "23b6f818-3def-4c40-a794-6d5a9c45a0ff", "0.2": "ff50db85-f7a9-4c03-8faf-9a17d932b435","1.1": "0d7c9d8e-9c84-44fb-b5a7-33becc01af14"}}
        expect(response.status).to eq(200)
        expect(Course.find_by(coursekey:"avain1").exercises.count).to eq(3)
      end
    end
  end
  
  describe "get scoreboard(s)" do
    context "when not logged in " do
      it "gives error message for scoreboard" do
        get 'scoreboard', :format => :json, params: {"id":"1"}
        expect(response.status).to eq(401)
      end
      it "gives error message for scoreboards" do
        get 'scoreboards', :format => :json
        expect(response.status).to eq(401)
      end
    end
    
    context "when logged in" do
      before(:each) do
        @course1 = FactoryGirl.create(:course, coursekey:"key1")
        @course2 = FactoryGirl.create(:course, coursekey:"key2")
        @exercise1 = Exercise.create(course_id: @course1.id, html_id:"id1")  
        @exercise2 = Exercise.create(course_id: @course1.id, html_id:"id2")
        @opiskelija1 = FactoryGirl.create(:user, username:"o1", name:"pekka", email:"o1@o.o")
        @opiskelija2 = FactoryGirl.create(:user, username:"o2", name:"bruce", email:"o2@o.o")
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
        get 'scoreboards', :format => :json
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
        get 'scoreboards', :format => :json
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expect(body.keys).to contain_exactly("key1","key2")
      end
      
      it "return a scoreboard for teacher" do
        sign_in @ope1
        get 'scoreboard', :format => :json, params: {"id":@course1.id}
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expect(body.keys).to contain_exactly("pekka","bruce")
      end
    end
  end
  
    
  describe "Create" do
    it "creates new Course with valid params" do
      course = Course.create! valid_attributes
      expect(Course.count).to eq(1)
    end

    #Ilmeisesti luo myös invalid parametreillä?
    #it "doesn't create with invalid params" do
    #  course2 = Course.create invalid_attributes
    #  expect(course2.name).to match("examplekey")
    #end

  end

  describe "GET #new" do
    it "assigns a new course as @course" do
      get :new, params: {}, session: valid_session
      expect(assigns(:course)).to be_a_new(Course)
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {{html_id: "exampleHtmlId", coursekey:"NEWkey", name:"matikka1"}}

      
      it "assigns the requested course as @course" do
        course = Course.create! valid_attributes
        put :update, params: {id: course.to_param, course: valid_attributes}, session: valid_session
        expect(assigns(:course)).to eq(course)
      end

    end

  end

  describe "DELETE #destroy" do
    it "destroys the requested course" do
      course = Course.create! valid_attributes
      expect {
        delete :destroy, params: {id: course.to_param}, session: valid_session
      }.to change(Course, :count).by(-1)
    end

    it "destroys courses exercises" do
      course = Course.create! valid_attributes
      exercise = Exercise.create html_id: "exerc_htmlId", name: "testexercise", course_id: course.id
      expect {
        delete :destroy, params: {id: course.to_param}, session: valid_session
      }.to change(Exercise, :count).by(-1)
    end
  end

end
