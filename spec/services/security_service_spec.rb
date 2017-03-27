require 'rails_helper'

RSpec.describe SecurityService, type: :service do

  describe "fake_courses?" do
    before(:each) do
      @ope1 = FactoryGirl.create(:user, email:"u1@o.o")
      @ope2 = FactoryGirl.create(:user, email:"u2@o.o")
      @course1 = FactoryGirl.create(:course, coursekey:"key1")
    end
  
    it "no teachers" do
      expect(SecurityService.fake_courses?.empty?).to eq(true)
    end
    it "not enough courses" do
      max_ok = FAKE_COURSES_CHECK_MIN - 1
      max_ok.times do
          Teaching.create(user_id: @ope2.id, course_id: @course1.id)
      end
      expect(SecurityService.fake_courses?.empty?).to eq(true)
    end
    
    it "enough students" do
      @student = FactoryGirl.create(:user, email:"u3@o.o")
      FAKE_COURSES_CHECK_MIN.times do
          Teaching.create(user_id: @ope1.id, course_id: @course1.id)
      end
      FAKE_COURSES_STUDENT_MIN.times do
          Attendance.create(user_id: @student.id, course_id: @course1.id)
      end
      expect(SecurityService.fake_courses?.empty?).to eq(true)
    end
    it "not enough students" do
      FAKE_COURSES_CHECK_MIN.times do
          Teaching.create(user_id: @ope1.id, course_id: @course1.id)
          Teaching.create(user_id: @ope2.id, course_id: @course1.id)
      end
      result = SecurityService.fake_courses?
      expect(result.empty?).to eq(false)
      expect(result.size).to eq(2)
      expect(result[0].keys).to contain_exactly("id","name","email","students","courses")
      expect(result[0]["courses"][0]["coursekey"]).to eq(@course1.coursekey)
    end
    
  end

end
