require 'rails_helper'

RSpec.describe ExerciselistService, type: :service do

  describe "basic methods" do
    
    it "elist_id_by_html_id(hid)" do
      expect(ExerciselistService.elist_id_by_html_id("aaabbb")).to eq(nil)
      e = Exerciselist.create(html_id: "aaa111")
      expect(ExerciselistService.elist_id_by_html_id("aaa111")).to eq(e.id)
    end
    
    it "all_exerciselists" do
      expect(ExerciselistService.all_exerciselists.size).to eq(0)
      e = Exerciselist.create(html_id: "aaa111")
      expect(ExerciselistService.all_exerciselists.size).to eq(1)
      expect(e.html_id).to eq("aaa111")
    end
    it "delete(id)" do
      e = Exerciselist.create(html_id: "aaa111")
      expect(ExerciselistService.delete(e.id + 1)).to eq(0)
      expect(ExerciselistService.delete(e.id)).to eq(1)
      expect(ExerciselistService.all_exerciselists.size).to eq(0)
    end
    it "new_list(html_id)" do
      e = Exerciselist.create(html_id: "aaa111")
      expect(ExerciselistService.new_list("aaa111")).to eq(nil)
      expect(ExerciselistService.new_list("aaa222")).not_to eq(nil)
      expect(ExerciselistService.all_exerciselists.size).to eq(2)
    end
    it "exercises_by_html_id(hid)" do
      expect(ExerciselistService.exercises_by_html_id("none")).to eq(nil)
      e = Exerciselist.create(html_id: "aaa111")
      expect(ExerciselistService.exercises_by_html_id(e.html_id)).to eq([])
      ExerciseService.create_exercise(e.html_id, "id1")
      ExerciseService.create_exercise(e.html_id, "id2")
      exs = ExerciselistService.exercises_by_html_id(e.html_id)
      expect(exs.size).to eq(2)
      expect(exs.include? "id1").to eq(true)
      expect(exs.include? "id2").to eq(true)
    end
    
  end

end
