require 'rails_helper'

RSpec.describe TeachingService, type: :service do

  describe "basic methods" do
    before(:each) do
      @ope = FactoryGirl.create(:user, email:"u1@o.o")
      @ope2 = FactoryGirl.create(:user, email:"u2@o.o")
      @elist = FactoryGirl.create(:exerciselist)
      @course = FactoryGirl.create(:course, exerciselist_id: @elist.id, coursekey:"key1")
      Teaching.create(user_id: @ope.id, course_id: @course.id)
    end
    it "teacher_on_course?(sid, cid)" do
      expect(TeachingService.all_teachings.count).to eq(1)
      expect(TeachingService.teacher_on_course?(666, 666)).to eq(false)
      expect(TeachingService.teacher_on_course?(@ope.id, 666)).to eq(false)
      expect(TeachingService.teacher_on_course?(666, @course.id)).to eq(false)
      expect(TeachingService.teacher_on_course?(@ope2.id, @course.id)).to eq(false)
      expect(TeachingService.teacher_on_course?(@ope.id, @course.id)).to eq(true)
    end
    it "is_teacher?(sid)" do
      expect(TeachingService.is_teacher?(666)).to eq(false)    
      expect(TeachingService.is_teacher?(@ope.id)).to eq(true)
      expect(TeachingService.is_teacher?(@ope2.id)).to eq(false)
    end
    it "is_archived?(sid, cid)" do
      expect(TeachingService.is_archived?(@ope, @course.id)).to eq(false)
    end
    it "create_teaching(sid, cid)" do
      expect(TeachingService.number_of_teachings).to eq(1)
      TeachingService.create_teaching(@ope2.id, @course.id)
      expect(TeachingService.number_of_teachings).to eq(2)
      expect(TeachingService.teacher_on_course?(@ope2, @course.id)).to eq(true)
    end
    it "change_archived_status(sid, cid, status)" do
      TeachingService.change_archived_status(@ope.id, @course.id, "purple")
      expect(TeachingService.is_archived?(@ope.id, @course.id)).to eq(false)
      TeachingService.change_archived_status(@ope.id, @course.id, "true")
      expect(TeachingService.is_archived?(@ope.id, @course.id)).to eq(true)
      TeachingService.change_archived_status(@ope.id, @course.id, "false")
      expect(TeachingService.is_archived?(@ope.id, @course.id)).to eq(false)
    end
    it "courses_created_today(sid)" do
      expect(TeachingService.courses_created_today(@ope.id)).to eq(1)
      expect(TeachingService.courses_created_today(@ope2.id)).to eq(0)
    end
    it "teacher_courses_ids(sid)" do
      expect(TeachingService.teacher_courses_ids(@ope2.id).size).to eq(0)
      ids = TeachingService.teacher_courses_ids(@ope.id)
      expect(ids.size).to eq(1)
      expect(ids.include? @course.id).to eq(true)
    end
  end
  
  describe "more complex methods" do
    it "course_count_rank" do
      expect(TeachingService.course_count_rank.empty?).to eq(true)
      @ope1 = FactoryGirl.create(:user, email:"u1@o.o")
      @ope2 = FactoryGirl.create(:user, email:"u2@o.o")
      @ope3 = FactoryGirl.create(:user, email:"u3@o.o")
      @elist = FactoryGirl.create(:exerciselist)
      @course1 = FactoryGirl.create(:course, exerciselist_id: @elist.id, coursekey:"key1")
      @course2 = FactoryGirl.create(:course, exerciselist_id: @elist.id, coursekey:"key2")
      @course3 = FactoryGirl.create(:course, exerciselist_id: @elist.id, coursekey:"key3")
      Teaching.create(user_id: @ope2.id, course_id: @course2.id)
      Teaching.create(user_id: @ope1.id, course_id: @course1.id)
      Teaching.create(user_id: @ope1.id, course_id: @course2.id)
      Teaching.create(user_id: @ope3.id, course_id: @course3.id)
      Teaching.create(user_id: @ope3.id, course_id: @course2.id)
      Teaching.create(user_id: @ope3.id, course_id: @course1.id)
      result = TeachingService.course_count_rank
      expect(result.size).to eq(3)
      expect(result).to eq({@ope3.id => 3, @ope1.id => 2, @ope2.id => 1})
    end

  end
end
