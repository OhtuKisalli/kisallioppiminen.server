require 'rails_helper'

RSpec.describe ExerciseService, type: :service do
  
  describe "basic methods" do
    before(:each) do
      @course = FactoryGirl.create(:course, coursekey:"key1")
      @e1 = ExerciseService.create_exercise(@course.id, "id1")
    end
    
    it "exercise_by_id(id)" do
      expect(ExerciseService.exercise_by_id(666)).to eq(nil)
      expect(ExerciseService.exercise_by_id(@e1.id)).not_to eq(nil)
    end
    
    it "exercise_ids_of_course(cid)" do
      @e2 = ExerciseService.create_exercise(@course.id, "id2")
      ids = ExerciseService.exercise_ids_of_course(@course.id)
      expect(ids.size).to eq(2)
      expect(ids.include?(@e1.id)).to eq(true)
      expect(ids.include?(@e2.id)).to eq(true)
      expect(ExerciseService.exercise_ids_of_course(666).size).to eq(0)
    end
    
    it "exercise_by_course_id_and_html_id(cid, hid)" do
      expect(ExerciseService.exercise_by_course_id_and_html_id(666, "idid")).to eq(nil)
      expect(ExerciseService.exercise_by_course_id_and_html_id(@course.id, "id1")).not_to eq(nil)
    end
    
    it "create_exercise(cid, hid)" do
      expect(Exercise.all.count).to eq(1)
      ExerciseService.create_exercise(@course.id, "id2")
      expect(ExerciseService.all_exercises.count).to eq(2)
    end
  end
  
  describe "more complex methods" do
      before(:each) do
        @course = FactoryGirl.create(:course, coursekey:"key1")
      end
      it "adds exercises to course" do
        exs = {"2" => "id2", "3" => "id3"}
        expect(@course.exercises.count).to eq(0)
        ExerciseService.add_exercises_to_course(exs, @course.id)
        expect(@course.exercises.count).to eq(2)
        expect(ExerciseService.exercise_by_course_id_and_html_id(@course.id, "id2")).not_to eq(nil)
        expect(ExerciseService.exercise_by_course_id_and_html_id(@course.id, "id3")).not_to eq(nil)
      end
      it "doesnt allow to add same exercises again" do
        exs = {"2" => "id2", "3" => "id3"}
        ExerciseService.add_exercises_to_course(exs, @course.id)
        expect(@course.exercises.count).to eq(2)
        ExerciseService.add_exercises_to_course(exs, @course.id)
        expect(@course.exercises.count).to eq(2)
        exs = {"2" => "id2", "3" => "id4"}
        ExerciseService.add_exercises_to_course(exs, @course.id)
        expect(@course.exercises.count).to eq(3)
      end
  end

end
