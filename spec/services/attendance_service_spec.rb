require 'rails_helper'

RSpec.describe AttendanceService, type: :service do

  describe "basic methods" do
    before(:each) do
      @student = FactoryGirl.create(:user, email:"u1@o.o")
      @student2 = FactoryGirl.create(:user, email:"u2@o.o")
      @course = FactoryGirl.create(:course, coursekey:"key1")
      Attendance.create(user_id: @student.id, course_id: @course.id)
    end
    it "user_on_course?(sid, cid)" do
      expect(AttendanceService.user_on_course?(@student.id, @course.id)).to eq(true)
      expect(AttendanceService.user_on_course?(@student2.id, @course.id)).to eq(false)
    end
    it "student_course_archived?(sid, cid)" do
      expect(AttendanceService.student_course_archived?(@student.id, @course.id)).to eq(false)
      AttendanceService.change_archived_status(@student.id, @course.id, "true")
      expect(AttendanceService.student_course_archived?(@student.id, @course.id)).to eq(true)
    end
    it "all_attendances" do
      expect(AttendanceService.all_attendances.size).to eq(1)
      Attendance.create(user_id: @student2.id, course_id: @course.id)
      expect(AttendanceService.all_attendances.size).to eq(2)
      Attendance.first.delete
      Attendance.first.delete
      expect(AttendanceService.all_attendances.size).to eq(0)
    end
    it "create_attendance(sid, cid)" do
      expect(Attendance.all.count).to eq(1)  
      expect(AttendanceService.create_attendance(@student.id, @course.id)).to eq(false)
      expect(AttendanceService.create_attendance(33, @course.id)).to eq(false)
      expect(AttendanceService.create_attendance(@student2.id, 33)).to eq(false)
      expect(Attendance.all.count).to eq(1)
      expect(AttendanceService.create_attendance(@student2.id, @course.id)).to eq(true)
      expect(Attendance.all.count).to eq(2)
    end
    it "change_archived_status(sid, cid, status)" do
      AttendanceService.change_archived_status(@student.id, @course.id, "purple")
      expect(AttendanceService.is_archived?(@student.id, @course.id)).to eq(false)
      AttendanceService.change_archived_status(@student.id, @course.id, "true")
      expect(AttendanceService.is_archived?(@student.id, @course.id)).to eq(true)
      AttendanceService.change_archived_status(@student.id, @course.id, "false")
      expect(AttendanceService.is_archived?(@student.id, @course.id)).to eq(false)
    end
    it "add_new_course_to_user(sid, cid)" do
      courseshash = AttendanceService.add_new_course_to_user(@student2.id, @course.id)
      expect(courseshash.keys).to contain_exactly(@course.coursekey)
      @course2 = FactoryGirl.create(:course, coursekey:"key2")
      courseshash2 = AttendanceService.add_new_course_to_user(@student2.id, @course2.id)
      expect(courseshash2.keys).to contain_exactly(@course.coursekey, @course2.coursekey)
    end
    it "get_attendance(sid, cid)" do
      expect(AttendanceService.get_attendance(55, 55)).to eq(nil)
      expect(AttendanceService.get_attendance(@student.id, 55)).to eq(nil)
      expect(AttendanceService.get_attendance(55, @course.id)).to eq(nil)
      expect(AttendanceService.get_attendance(@student.id, @course.id)).not_to eq(nil)
    end
    
  end
end
