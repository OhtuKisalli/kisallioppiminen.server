require 'rails_helper'

RSpec.describe ScheduleService, type: :service do

  describe "basic methods" do
    before(:each) do
      @course = FactoryGirl.create(:course, coursekey:"key1")
    end
    it "all_schedules" do
      expect(ScheduleService.all_schedules.any?).to eq(false)
      Schedule.create(name: "nimi", course_id: @course.id, exercises: [])
      expect(ScheduleService.all_schedules.any?).to eq(true)
    end
    it "name_reserved?(cid, name)" do
      expect(ScheduleService.name_reserved?(@course.id, "nimi")).to eq(false)
      Schedule.create(name: "nimi", course_id: @course.id, exercises: [])
      expect(ScheduleService.name_reserved?(@course.id, "nimi")).to eq(true)
    end
    it "add_new_schedule(cid, name)" do
      expect(ScheduleService.add_new_schedule(@course.id + 1, "nimi")).to eq(false)
      expect(ScheduleService.all_schedules.any?).to eq(false)
      expect(ScheduleService.add_new_schedule(@course.id, "nimi")).to eq(true)
      expect(ScheduleService.all_schedules.any?).to eq(true)
      schedule = ScheduleService.all_schedules.first
      expect(schedule.name).to eq("nimi")
      expect(schedule.course_id).to eq(@course.id)
      expect(schedule.exercises).to eq([])
      expect(ScheduleService.add_new_schedule(@course.id, "nimi")).to eq(false)
      expect(ScheduleService.all_schedules.count).to eq(1)
    end
    
  end

end
