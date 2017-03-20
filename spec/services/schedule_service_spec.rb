require 'rails_helper'

RSpec.describe ScheduleService, type: :service do

  describe "basic methods" do
    before(:each) do
      @course = FactoryGirl.create(:course, coursekey:"key1")
      @exercise1 = ExerciseService.create_exercise(@course.id, "id1")
      @exercise2 = ExerciseService.create_exercise(@course.id, "id2")
      @exercise3 = ExerciseService.create_exercise(@course.id, "id3")
      exs = [] 
      exs << @exercise1.html_id
      exs << @exercise2.html_id
      @course.exercises << @exercise1
      @course.exercises << @exercise2
      @course.exercises << @exercise3
      @course.save
      DeadlineService.create_deadline(@course.id, "nimi", "2017-05-05 10:28:33", exs)
    end
    it "all_schedules" do
      expect(ScheduleService.number_of_schedules).to eq(2)
      expect(ScheduleService.all_schedules.first.exercise_id).to eq(@exercise1.id)
      expect(ScheduleService.all_schedules.last.exercise_id).to eq(@exercise2.id)
    end
    it "create_schedule(eid,did)" do
      ScheduleService.create_schedule(@exercise3.id, Deadline.first.id)
      expect(ScheduleService.number_of_schedules).to eq(3)
      expect(Schedule.last.exercise_id).to eq(@exercise3.id)
    end
    
  end

end
