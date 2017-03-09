require 'rails_helper'

RSpec.describe DeadlineService, type: :service do

  describe "deadlineservice" do
    before(:each) do
      Deadline.create(description:"name", deadline: "2017-03-05 20:28:33")
      Deadline.create(description:"name2", deadline: "2017-01-01 10:28:33")
    end
    it "all_deadlines lists all deadlines" do
      deadline = DeadlineService.all_deadlines
      expect(deadline.count).to eq(2)
      expect(deadline.first.description).to eq("name")
      expect(deadline.last.description).to eq("name2")
    end
    it "deadline_by_id returns nil of no exercise found" do
      expect(DeadlineService.deadline_by_id(666)).to eq(nil)
    end
    it "create_deadline creates deadline" do
      @course = FactoryGirl.create(:course, coursekey:"key1")
      @exercise1 = Exercise.create(course_id: @course.id, html_id:"id1")  
      @exercise2 = Exercise.create(course_id: @course.id, html_id:"id2")
      @exercise3 = Exercise.create(course_id: @course.id, html_id:"id3")
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
  
  end

end
