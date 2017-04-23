require 'rails_helper'

RSpec.describe ExerciseService, type: :service do
  
  describe "basic methods" do
    before(:each) do
      @course = FactoryGirl.create(:course, coursekey:"key1")
      @e1 = ExerciseService.create_exercise(@course.html_id, "id1")
    end
    
    it "exercise_by_id(id)" do
      expect(ExerciseService.exercise_by_id(666)).to eq(nil)
      expect(ExerciseService.exercise_by_id(@e1.id)).not_to eq(nil)
    end
    
    it "exercise_ids_of_course(cid)" do
      @e2 = ExerciseService.create_exercise(@course.html_id, "id2")
      ids = ExerciseService.exercise_ids_of_course(@course.id)
      expect(ids.size).to eq(2)
      expect(ids.include?(@e1.id)).to eq(true)
      expect(ids.include?(@e2.id)).to eq(true)
      expect(ExerciseService.exercise_ids_of_course(666).size).to eq(0)
    end
    
    it "exercises_by_course_id_and_html_id_array(cid, exercises)" do
      expect(ExerciseService.exercises_by_course_id_and_html_id_array(@course.id + 5, [])).to eq([])
      expect(ExerciseService.exercises_by_course_id_and_html_id_array(@course.id, [])).to eq([])
      @e2 = ExerciseService.create_exercise("nocourses", "id2")
      exs = []
      exs << @e2.html_id
      exs << @e1.html_id
      expect(ExerciseService.exercises_by_course_id_and_html_id_array(@course.id, exs).size).to eq(1)
      expect(ExerciseService.exercises_by_course_id_and_html_id_array(@course.id, exs)[0].id).to eq(@e1.id)
      @course2 = FactoryGirl.create(:course, html_id: "newcourse", coursekey:"key2")
      expect(ExerciseService.exercises_by_course_id_and_html_id_array(@course2.id, exs).size).to eq(0)
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
    
    it "html_ids_of_exercises_by_course_id(cid)" do
      html_ids = ExerciseService.html_ids_of_exercises_by_course_id(666)
      expect(html_ids.size).to eq(0)
      html_ids = ExerciseService.html_ids_of_exercises_by_course_id(@course.id)
      expect(html_ids.size).to eq(1)
      expect(html_ids[0]).to eq(@e1.html_id)
    end
    
    it "exercise_on_course?(cid, hid)" do
      @course2 = FactoryGirl.create(:course, coursekey:"key2")
      expect(ExerciseService.exercise_on_course?(@course2.id, @e1.html_id)).to eq(false)
      expect(ExerciseService.exercise_on_course?(@course.id, @e1.html_id)).to eq(true)
    end
    
    it "exercise_on_list?(list_html_id, e_html_id)" do
      expect(ExerciseService.exercise_on_list?("foo", "bar")).to eq(false)
      exs = ["id1", "id2"]
      AdminService.save_exercises(exs, "htmlid1")
      expect(ExerciseService.exercise_on_list?("htmlid1", "ididid")).to eq(false)
      expect(ExerciseService.exercise_on_list?("htmlid111", "id1")).to eq(false)
      expect(ExerciseService.exercise_on_list?("htmlid1", "id1")).to eq(true)
    end
    
  end
    

end
