require 'rails_helper'

RSpec.describe CourseService, type: :service do

  describe "basic methods" do
    before(:each) do
      @course = FactoryGirl.create(:course, coursekey:"key1")
    end
    it "find_by_coursekey" do
      expect(CourseService.find_by_coursekey("eioo")).to eq(nil)
      expect(CourseService.find_by_coursekey(@course.coursekey).id).to eq(@course.id)
    end
    it "course_has_exercise?(course,hid)" do
      exercise1 = ExerciseService.create_exercise(@course.html_id, "id1")
      expect(CourseService.course_has_exercise?(@course,"eioo")).to eq(false)
      expect(CourseService.course_has_exercise?(@course,exercise1.html_id)).to eq(true)
    end  
    
    it "self.all_courses" do
      expect(CourseService.all_courses.count).to eq(1)
      Course.delete(@course.id)
      expect(CourseService.all_courses.count).to eq(0)
    end
    it "course_by_id(cid)" do
      expect(CourseService.course_by_id(666)).to eq(nil)
      expect(CourseService.course_by_id(@course.id)).not_to eq(nil)
    end
    it "coursekey_reserved?(key)" do
      expect(CourseService.coursekey_reserved?("aa33aa33")).to eq(false)
      expect(CourseService.coursekey_reserved?(@course.coursekey)).to eq(true)
    end
    it "create_new_course(sid, params)" do
      @ope = FactoryGirl.create(:user, email:"o2@o.o")
      @elist = FactoryGirl.create(:exerciselist)
      proper_params = {"coursekey":"key1111", "name":"nimi1", "html_id":"id222", "startdate":"2017-02-02", "enddate":"2017-10-11", exerciselist_id: @elist.id}
      improper_params = {"coursekey": @course.coursekey, "name":"nimi1", "html_id":"id222", "startdate":"2017-02-02", "enddate":"2017-10-11", exerciselist_id: @elist.id}
      expect(CourseService.create_new_course(@ope.id, improper_params)).to eq(-1)
      expect(CourseService.create_new_course(@ope.id, proper_params)).not_to eq(-1)
      expect(CourseService.find_by_coursekey("key1111")).not_to eq(nil)
    end
    it "cannot create course if exerciselist doesnt exist" do
      @ope = FactoryGirl.create(:user, email:"o2@o.o")
      improper_params = {"coursekey": @course.coursekey, "name":"nimi1", "html_id":"id222", "startdate":"2017-02-02", "enddate":"2017-10-11"}
      expect(CourseService.create_new_course(@ope.id, improper_params)).to eq(-1)
    end
    
    it "teacher_courses(id)" do
      @ope = FactoryGirl.create(:user, email:"o2@o.o")
      expect(CourseService.teacher_courses(@ope.id)).to eq([])
      TeachingService.create_teaching(@ope.id, @course.id)
      result = CourseService.teacher_courses(@ope.id)
      expect(result.size).to eq(1)
      expect(result.first.keys).to contain_exactly("id", "coursekey", "html_id", "startdate", "enddate", "name", "archived")
    end
    it "student_courses(id)" do
      @student = FactoryGirl.create(:user, email:"u2@o.o")
      expect(CourseService.student_courses(@student.id)).to eq([])
      AttendanceService.create_attendance(@student.id, @course.id)
      result = CourseService.student_courses(@student.id)
      expect(result.size).to eq(1)
      expect(result.first.keys).to contain_exactly("id", "coursekey", "html_id", "startdate", "enddate", "name", "archived")
    end
    it "basic_course_info(course)" do
      result = CourseService.basic_course_info(@course) 
      expect(result.keys).to contain_exactly("id","coursename","coursekey","html_id","startdate","enddate")
      expect(result["coursekey"]).to eq(@course.coursekey)
    end
    it "student_checkmarks_course_info(sid, cid)" do
      @student = FactoryGirl.create(:user, email:"u2@o.o")
      AttendanceService.create_attendance(@student.id, @course.id)
      result = CourseService.student_checkmarks_course_info(@student.id, @course.id)
      expect(result.keys).to contain_exactly("coursekey","html_id","archived")
      expect(result["coursekey"]).to eq(@course.coursekey)
    end
    it "delete_course(cid)" do
      expect(CourseService.delete_course(@course.id + 1)).to eq(false)
      ExerciseService.create_exercise(@course.html_id, "id1")
      @student = FactoryGirl.create(:user, email:"u2@o.o")
      AttendanceService.create_attendance(@student.id, @course.id)
      TeachingService.create_teaching(@student.id, @course.id)
      expect(CourseService.all_courses.count).to eq(1)
      expect(TeachingService.all_teachings.count).to eq(1)
      expect(AttendanceService.all_attendances.size).to eq(1)
      expect(ExerciseService.all_exercises.count).to eq(1)
      expect(CourseService.delete_course(@course.id)).to eq(true)
      expect(CourseService.all_courses.count).to eq(0)
      expect(TeachingService.all_teachings.count).to eq(0)
      expect(AttendanceService.all_attendances.size).to eq(0)
      expect(ExerciseService.all_exercises.count).to eq(1)
    end
    
  end
  
  describe "more complex methods" do
    before(:each) do
      @course = FactoryGirl.create(:course, coursekey:"key1")
    end
  
    it "update_course?(id,params)" do
      expect(CourseService.find_by_coursekey("key1111")).to eq(nil)
      @course2 = FactoryGirl.create(:course, coursekey:"key2")
      proper_params = {"coursekey":"key1111", "name":"nimi1", "html_id":"id222", "startdate":"2017-02-02", "enddate":"2017-10-11"}
      expect(CourseService.update_course?(@course2.id, proper_params)).to eq(true)
      expect(CourseService.find_by_coursekey("key1111")).not_to eq(nil)
    end
    
    it "update_course?(id, params) - reserved coursekey" do
      @course2 = FactoryGirl.create(:course, coursekey:"key2")
      improper_params = {"coursekey": @course.coursekey, "name":"nimi1", "html_id":"id222", "startdate":"2017-02-02", "enddate":"2017-10-11"}
      expect(CourseService.update_course?(@course2.id, improper_params)).to eq(false)
    end
    
    it "statistics(cid)" do
      ExerciseService.create_exercise(@course.html_id, "id1")
      ExerciseService.create_exercise(@course.html_id, "id2")
      @student1 = FactoryGirl.create(:user, email:"u1@o.o")
      @student2 = FactoryGirl.create(:user, email:"u2@o.o")
      @student3 = FactoryGirl.create(:user, email:"u3@o.o")
      @student4 = FactoryGirl.create(:user, email:"u4@o.o")
      AttendanceService.create_attendance(@student1.id, @course.id)
      AttendanceService.create_attendance(@student2.id, @course.id)
      AttendanceService.create_attendance(@student3.id, @course.id)
      AttendanceService.create_attendance(@student4.id, @course.id)
      CheckmarkService.save_student_checkmark(@student1, @course.id, "id1", "green")
      CheckmarkService.save_student_checkmark(@student2, @course.id, "id1", "red")
      CheckmarkService.save_student_checkmark(@student3, @course.id, "id1", "yellow")
      CheckmarkService.save_student_checkmark(@student4, @course.id, "id1", "green")
      stats = CourseService.statistics(@course.id)
      expect(stats.size).to eq(3)
      expect(stats.keys).to contain_exactly("total","id1","id2")
      expect(stats["total"]).to eq(4)
      expect(stats["id1"].keys).to contain_exactly("green","yellow","red")
      expect(stats["id2"].keys).to contain_exactly("green","yellow","red")
      expect(stats["id1"]["green"]).to eq(2)
      expect(stats["id2"]["green"]).to eq(0)
      expect(stats["id1"]["red"]).to eq(1)
      expect(stats["id2"]["red"]).to eq(0)
      expect(stats["id1"]["yellow"]).to eq(1)
      expect(stats["id2"]["yellow"]).to eq(0)
    end
  
  end
 
end
