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
      exercise1 = ExerciseService.create_exercise(@course.id, "id1")
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
      proper_params = {"coursekey":"key1111", "name":"nimi1", "html_id":"id222", "startdate":"2017-02-02", "enddate":"2017-10-11"}
      improper_params = {"coursekey": @course.coursekey, "name":"nimi1", "html_id":"id222", "startdate":"2017-02-02", "enddate":"2017-10-11"}
      expect(CourseService.create_new_course(@ope.id, improper_params)).to eq(-1)
      expect(CourseService.create_new_course(@ope.id, proper_params)).to eq(2)
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
  
  end

 
end
