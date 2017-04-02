require 'rails_helper'

RSpec.describe CheckmarkService, type: :service do

  describe "basic methods" do
    before(:each) do
      @course = FactoryGirl.create(:course, coursekey:"key1")
      @e1 = ExerciseService.create_exercise(@course.html_id, "id1")
      @student = FactoryGirl.create(:user, email:"u2@o.o")
    end
    it "all_checkmarks_count" do
      expect(CheckmarkService.all_checkmarks_count).to eq(0)
      AttendanceService.create_attendance(@student.id, @course.id)
      expect(CheckmarkService.all_checkmarks_count).to eq(0)
      CheckmarkService.save_student_checkmark(@student.id, @course.id, @e1.html_id, "green")
      expect(CheckmarkService.all_checkmarks_count).to eq(1)
    end
    it "get_checkmark_status(sid,cid,hid)" do
      create_attendance_and_checkmark(@student.id, @course.id, @e1.html_id, "green")
      status1 = CheckmarkService.get_checkmark_status(@student.id, @course.id, @e1.html_id)
      status2 = CheckmarkService.get_checkmark_status(666, 666, @e1.html_id)
      expect(status1).to eq("green")
      expect(status2).to eq(nil)
    end
    it "student_checkmarks(cid, sid)" do
      expect(CheckmarkService.student_checkmarks(666, 666).size).to eq(0)
      @e2 = ExerciseService.create_exercise(@course.html_id, "id2")
      create_attendance_and_checkmark(@student.id, @course.id, @e1.html_id, "green")
      create_attendance_and_checkmark(@student.id, @course.id, @e2.html_id, "red")
      cms = CheckmarkService.student_checkmarks(@course.id, @student.id)
      expect(cms.size).to eq(2)
      expect(cms[0]["id"]).to eq(@e1.html_id)
      expect(cms[1]["id"]).to eq(@e2.html_id)
      expect(cms[0]["status"]).to eq("green")
      expect(cms[1]["status"]).to eq("red")
    end
    it "save_student_checkmark(sid, cid, hid, status)" do
      AttendanceService.create_attendance(@student.id, @course.id)
      expect(CheckmarkService.all_checkmarks_count).to eq(0)
      CheckmarkService.save_student_checkmark(@student.id, @course.id, @e1.html_id, "green")
      expect(CheckmarkService.all_checkmarks_count).to eq(1)
      expect(CheckmarkService.student_checkmarks(@course.id, @student.id)[0]["status"]).to eq("green")
      CheckmarkService.save_student_checkmark(@student.id, @course.id, @e1.html_id, "red")
      expect(CheckmarkService.all_checkmarks_count).to eq(1)
      expect(CheckmarkService.student_checkmarks(@course.id, @student.id)[0]["status"]).to eq("red")
    end
  end
  
  describe "more complex methods" do
    before(:each) do
      @course = FactoryGirl.create(:course, coursekey:"key1")
      @e1 = ExerciseService.create_exercise(@course.html_id, "id1")
      @e2 = ExerciseService.create_exercise(@course.html_id, "id2")
      @student = FactoryGirl.create(:user, email:"u2@o.o")
    end
    it "add_gray_checkmarks(exercisearray, sid, cid)" do
      create_attendance_and_checkmark(@student.id, @course.id, @e1.html_id, "green")
      cms = CheckmarkService.student_checkmarks(@course.id, @student.id)
      expect(cms.size).to eq(1)
      cms = CheckmarkService.add_gray_checkmarks(cms, @student.id, @course.id)
      expect(cms.size).to eq(2)
      expect(cms[1]["id"]).to eq(@e2.html_id)
      expect(cms[1]["status"]).to eq("gray")
    end
  end
  
  private
    def create_attendance_and_checkmark(sid, cid, hid, status)
      AttendanceService.create_attendance(sid, cid)
      CheckmarkService.save_student_checkmark(sid, cid, hid, status)
    end

end
