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
      exercise1 = Exercise.create(course_id: @course.id, html_id:"id1")
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
      expect(CourseService.teacher_courses(@ope.id)).to eq({})

      
    end
    
  end
  
  describe "more complex methods" do
    
  
  end

  # expect(CourseService.).to eq()
  # expect().to eq()
end
