require 'rails_helper'

RSpec.describe AdminService, type: :service do

  describe "basic methods" do
  
    it "download_exercises(url)" do
      expect(AdminService.download_exercises(nil)).to eq(nil)
    end
    
    it "save_exercises(exercises, hid)" do
      exs = ["id1", "id2"]
      AdminService.save_exercises(exs, "htmlid1")
      expect(ExerciselistService.all_exerciselists.first.html_id).to eq("htmlid1")
      expect(ExerciseService.all_exercises.count).to eq(2)
    end
    
    it "add_exercises(exercises, hid)" do
      exs = ["id1", "id2"]
      exs_new = ["id3"]
      AdminService.save_exercises(exs, "htmlid2")
      AdminService.add_exercises(exs_new, "htmlid2")
      exercises = ExerciselistService.exercises_by_html_id("htmlid2")
      expect(exercises.size).to eq(3)
      expect(exercises.include? "id3").to eq(true)
      AdminService.add_exercises(exs_new, "htmlid2")
      expect(exercises.size).to eq(3)
    end
    
  end

end
