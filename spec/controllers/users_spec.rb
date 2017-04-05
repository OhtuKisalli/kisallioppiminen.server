require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "session" do
    it "is_user_signed_in tells if user not signed in" do
      get 'is_user_signed_in', :format => :json
      body = JSON.parse(response.body)
      expected = {"has_sign_in" => false}
      expect(body).to eq(expected)
    end
    it "is_user_signed_in tells if user signed in" do
      @user = FactoryGirl.create(:user, first_name:"Bruce", email:"o2@o.o")
      sign_in @user
      get 'is_user_signed_in', :format => :json
      body = JSON.parse(response.body)
      expected = {"has_sign_in" => true}
      expect(body).to eq(expected)
    end
    it "get_session_user returns user id and first_name" do
      @user = FactoryGirl.create(:user, first_name:"Bruce", email:"o2@o.o")
      sign_in @user
      get 'get_session_user', :format => :json
      body = JSON.parse(response.body)
      expected = {"has_sign_in" => {"id" => @user.id, "first_name" => @user.first_name, "teacher"=>false, "student"=>false}}
      expect(body).to eq(expected)
    end
    it "get_session_user tells if user is teacher and student" do
      @student = FactoryGirl.create(:user, first_name:"Bruce", email:"o4@o.o")
      @course = FactoryGirl.create(:course, coursekey:"key1")
      Attendance.create(user_id: @student.id, course_id: @course.id)
      Teaching.create(user_id: @student.id, course_id: @course.id)
      sign_in @student
      get 'get_session_user', :format => :json
      body = JSON.parse(response.body)
      expected = {"has_sign_in" => {"id" => @student.id, "first_name" => @student.first_name, "teacher"=>true, "student"=>true}}
      expect(body).to eq(expected)
    end
    
    it "get_session_user returns nil for user not logged in" do
      get 'get_session_user', :format => :json
      body = JSON.parse(response.body)
      expected = {"has_sign_in" => nil}
      expect(body).to eq(expected)
    end

  end

end
