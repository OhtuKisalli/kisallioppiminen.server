require 'rails_helper'

RSpec.describe TeachingService, type: :service do

  describe "basic methods" do
    before(:each) do
      @ope = FactoryGirl.create(:user, email:"u1@o.o")
      @ope2 = FactoryGirl.create(:user, email:"u2@o.o")
      @course = FactoryGirl.create(:course, coursekey:"key1")
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
    
  end

end
