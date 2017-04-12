require 'rails_helper'

RSpec.describe ScheduleService, type: :service do

  describe "basic methods" do
    before(:each) do
      @course = FactoryGirl.create(:course, coursekey:"key1")
    end
    it "all_schedules" do
      expect(ScheduleService.all_schedules.any?).to eq(false)
      Schedule.create(name: "nimi", color: 1, course_id: @course.id, exercises: [])
      expect(ScheduleService.all_schedules.any?).to eq(true)
    end
    it "name_reserved?(cid, name)" do
      expect(ScheduleService.name_reserved?(@course.id, "nimi")).to eq(false)
      Schedule.create(name: "nimi", color: 1, course_id: @course.id, exercises: [])
      expect(ScheduleService.name_reserved?(@course.id, "nimi")).to eq(true)
    end
    it "add_new_schedule(cid, name)" do
      expect(ScheduleService.add_new_schedule(@course.id + 1, "nimi", 1)).to eq(false)
      expect(ScheduleService.all_schedules.any?).to eq(false)
      expect(ScheduleService.add_new_schedule(@course.id, "nimi", 1)).to eq(true)
      expect(ScheduleService.all_schedules.any?).to eq(true)
      schedule = ScheduleService.all_schedules.first
      expect(schedule.name).to eq("nimi")
      expect(schedule.course_id).to eq(@course.id)
      expect(schedule.exercises).to eq([])
      expect(ScheduleService.add_new_schedule(@course.id, "nimi", 1)).to eq(false)
      expect(Schedule.count).to eq(1)
    end
    it "delete_schedule(id)" do
      s = Schedule.create(name: "nimi", color: 1, course_id: @course.id, exercises: [])
      ScheduleService.delete_schedule(s.id)
      expect(Schedule.count).to eq(0)
    end
    it "schedule_on_course?(cid, id)" do
      expect(ScheduleService.schedule_on_course?(@course.id, 666)).to eq(false)
      schedule = Schedule.create(name: "nimi", color: 1, course_id: @course.id, exercises: [])
      expect(ScheduleService.schedule_on_course?(@course.id, schedule.id)).to eq(true)
    end
    it "course_schedules(cid)" do
      expect(ScheduleService.course_schedules(@course.id + 1)).to eq([])
      expect(ScheduleService.course_schedules(@course.id)).to eq([])
      s1 = Schedule.create(name: "nimi", color: 1, course_id: @course.id, exercises: [])
      expected = [{"id": s1.id, "name": s1.name, "color": s1.color, "exercises": []}]
      expect(ScheduleService.course_schedules(@course.id)).to eq(expected)
      s2 = Schedule.create(name: "nimi2", color: 2, course_id: @course.id, exercises: ["aaa","bbb"])
      expected = [{"id": s1.id, "name": s1.name, "color": s1.color, "exercises": []},{"id": s2.id, "name": s2.name, "color": s2.color, "exercises": s2.exercises}]
      result = ScheduleService.course_schedules(@course.id)
      expect(result.size).to eq(2)
      expect(result).to eq(expected)
    end
    
  end

  describe "update_schedule_exercises(cid, schedules)" do
    it "course must exist" do
      expect(ScheduleService.update_schedule_exercises(1, [])).to eq(false)
    end
    it "doesnt do anything if schedule not exist" do
      @course = FactoryGirl.create(:course, coursekey:"key1")
      schedule = Schedule.create(name: "nimi", course_id: @course.id, exercises: [])
      s = (schedule.id + 1).to_s
      hash = {s => {"id1" => true}}
      expect(ScheduleService.update_schedule_exercises(@course.id, hash)).to eq(true)
      expect(schedule.exercises.size).to eq(0)
    end
    it "adds exercises to schedules" do
      @course = FactoryGirl.create(:course, coursekey:"key1")
      schedule = Schedule.create(name: "nimi", course_id: @course.id, exercises: [])
      schedule2 = Schedule.create(name: "nimi2", course_id: @course.id, exercises: [])
      id1 = schedule.id.to_s
      id2 = schedule2.id.to_s
      hash = {id1 => {"id1" => true, "id2" => true}, id2 => {"id1" => false}}
      expect(ScheduleService.update_schedule_exercises(@course.id, hash)).to eq(true)
      s1 = Schedule.where(name: "nimi").first
      s2 = Schedule.where(name: "nimi2").first
      expect(s1.exercises.include? "id1").to eq(true)
      expect(s1.exercises.include? "id2").to eq(true)
      expect(s2.exercises.include? "id1").to eq(false)
    end
    it "add/remove works correctly to values exist" do
      @course = FactoryGirl.create(:course, coursekey:"key2")
      schedule = Schedule.create(name: "name1", course_id: @course.id, exercises: ["id1"])
      schedule2 = Schedule.create(name: "name2", course_id: @course.id, exercises: ["id2"])
      expect(schedule.exercises.include? "id1").to eq(true)
      expect(schedule2.exercises.include? "id2").to eq(true)
      hash = {schedule.id.to_s => {"id1" => true}, schedule2.id.to_s => {"id2" => false}}
      expect(ScheduleService.update_schedule_exercises(@course.id, hash)).to eq(true)
      s1 = Schedule.where(name: "name1").first
      s2 = Schedule.where(name: "name2").first
      expect(s1.exercises.include? "id1").to eq(true)
      expect(s1.exercises.size).to eq(1)
      expect(s2.exercises.include? "id2").to eq(false)
      expect(s2.exercises.size).to eq(0)
    end
    
  end
  
end
