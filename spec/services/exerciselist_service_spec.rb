require 'rails_helper'

RSpec.describe ExerciselistService, type: :service do

  describe "basic methods" do
    
    it "elist_id_by_html_id(hid)" do
      expect(ExerciselistService.elist_id_by_html_id("aaabbb")).to eq(nil)
      e = Exerciselist.create(html_id: "aaa111")
      expect(ExerciselistService.elist_id_by_html_id("aaa111")).to eq(e.id)
    end
    
  end

end
