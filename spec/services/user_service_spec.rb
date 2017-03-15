require 'rails_helper'

RSpec.describe UserService, type: :service do

  describe "basic methods" do
    before(:each) do
      @u1 = FactoryGirl.create(:user, email:"o1@o.o")
    end
    it "all_users" do
      @u2 = FactoryGirl.create(:user, email:"o2@o.o")
      users = UserService.all_users
      expect(users.count).to eq(2)
      expect(users.first.id).to eq(@u1.id)
      expect(users.last.id).to eq(@u2.id)
    end
    it "teacher_courses(id)" do
      @course = FactoryGirl.create(:course, coursekey: "key1")
      expect(UserService.teacher_courses(33)).to eq(nil)
      expect(UserService.teacher_courses(@u1.id).size).to eq(0)
      TeachingService.create_teaching(@u1.id, @course.id)
      expect(UserService.teacher_courses(@u1.id).size).to eq(1)
    end
    it "student_courses(id)" do
      @course = FactoryGirl.create(:course, coursekey: "key1")
      expect(UserService.student_courses(33)).to eq(nil)
      expect(UserService.student_courses(@u1.id).size).to eq(0)
      AttendanceService.create_attendance(@u1.id, @course.id)
      expect(UserService.student_courses(@u1.id).size).to eq(1)
    end
  
  end

end
