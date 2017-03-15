require 'rails_helper'

RSpec.describe DeadlineService, type: :service do

  describe "deadlineservice" do
    before(:each) do
      @deadline1 = Deadline.create(description:"name", deadline: "2017-03-05 20:28:33")
      @deadline2 = Deadline.create(description:"name2", deadline: "2017-01-01 10:28:33")
    end
    it "all_deadlines lists all deadlines" do
      deadline = DeadlineService.all_deadlines
      expect(deadline.count).to eq(2)
      expect(deadline.first.description).to eq("name")
      expect(deadline.last.description).to eq("name2")
    end
    it "deadline_by_id" do
      expect(DeadlineService.deadline_by_id(666)).to eq(nil)
      expect(DeadlineService.deadline_by_id(@deadline1.id)).not_to eq(nil)
    end
    it "create_deadline creates deadline" do
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
      expect(DeadlineService.create_deadline(@course.id, "nimi", "2017-05-05 10:28:33", exs)).to eq(true)
      expect(Deadline.all.count).to eq(3)
      dl = Deadline.last
      expect(dl.exercises.count).to eq(2)
      expect(dl.exercises.first.id).to eq(@exercise1.id)
      expect(dl.exercises.last.id).to eq(@exercise2.id)
      expect(dl.deadline).to eq("2017-05-05 10:28:33")
      expect(@exercise1.deadlines.count).to eq(1)
      expect(@exercise2.deadlines.count).to eq(1)
      expect(@exercise3.deadlines.count).to eq(0)
    end
    it "tells if deadline is on course" do
      expect(DeadlineService.deadline_on_course?(1,1)).to eq(false)
      @course = FactoryGirl.create(:course, coursekey:"key1")
      expect(DeadlineService.deadline_on_course?(@course.id,1)).to eq(false)
      expect(DeadlineService.deadline_on_course?(@course.id,@deadline1.id)).to eq(false)
      @course2 = FactoryGirl.create(:course, coursekey:"key2")
      @exercise2 = ExerciseService.create_exercise(@course2.id, "id1")
      ScheduleService.create_schedule(@exercise2.id, @deadline2.id)
      expect(DeadlineService.deadline_on_course?(@course.id,@deadline2.id)).to eq(false)
      expect(DeadlineService.deadline_on_course?(@course2.id,@deadline2.id)).to eq(true)
    end
    it "deadline can be removed" do
      @course = FactoryGirl.create(:course, coursekey:"key2")
      @exercise1 = ExerciseService.create_exercise(@course.id, "id1")
      @exercise2 = ExerciseService.create_exercise(@course.id, "id2")
      @exercise3 = ExerciseService.create_exercise(@course.id, "id3")
      ScheduleService.create_schedule(1, 1)
      ScheduleService.create_schedule(2, 1)
      ScheduleService.create_schedule(2, 2)
      ScheduleService.create_schedule(3, 2)
      expect(ScheduleService.number_of_schedules).to eq(4)
      expect(Deadline.all.count).to eq(2)
      expect(@deadline1.exercises.count).to eq(2)
      DeadlineService.remove_deadline(@deadline1.id)
      expect(ScheduleService.number_of_schedules).to eq(2)
      expect(Deadline.all.count).to eq(1)
      expect(@deadline2.exercises.count).to eq(2)
      DeadlineService.remove_deadline(@deadline2.id)
      expect(ScheduleService.number_of_schedules).to eq(0)
    end
  
  end

end
