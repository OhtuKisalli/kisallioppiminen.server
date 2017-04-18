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
    it "delete_all_courses(sid)" do
      @course2 = FactoryGirl.create(:course, coursekey:"key2")
      @course3 = FactoryGirl.create(:course, coursekey:"key3")
      Teaching.create(user_id: @ope1.id, course_id: @course1.id)
      Teaching.create(user_id: @ope1.id, course_id: @course2.id)
      Teaching.create(user_id: @ope2.id, course_id: @course3.id)
      expect(TeachingService.teacher_courses_ids(@ope1.id).size).to eq(2)
      expect(TeachingService.teacher_courses_ids(@ope2.id).size).to eq(1)
      SecurityService.delete_all_courses(@ope1.id)
      expect(TeachingService.teacher_courses_ids(@ope1.id).size).to eq(0)
      expect(TeachingService.teacher_courses_ids(@ope2.id).size).to eq(1)
      expect(CourseService.all_courses.count).to eq(1)
    end
    it "block_user(sid)" do
      expect(@ope1.blocked).to eq(false)
      SecurityService.block_user(@ope1.id)
      @ope1 = UserService.user_by_id(@ope1.id)
      expect(@ope1.blocked).to eq(true)
    end
    
    it "unblock_user(sid)" do
      SecurityService.block_user(@ope2.id)
      @ope2 = UserService.user_by_id(@ope2.id)
      expect(@ope2.blocked).to eq(true)
      SecurityService.unblock_user(@ope2.id)
      @ope2 = UserService.user_by_id(@ope2.id)
      expect(@ope2.blocked).to eq(false)
    end
    
    it "safe_string?(param)" do
      expect(SecurityService.safe_string?("ThisStringIsOK")).to eq(true)
      expect(SecurityService.safe_string?('<script>alert("Hohoho");</script>')).to eq(false)
    end
    
  end

end
