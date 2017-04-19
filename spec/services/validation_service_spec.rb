require 'rails_helper'

RSpec.describe ValidationService, type: :service do

  describe "create course validations" do
  
    context "validate_coursekey(key)" do
      it "not blank" do
        msg = {"error"=>"Kurssiavain ei voi olla tyhjä."}
        expect(ValidationService.validate_coursekey(nil)).to eq(msg)
      end
      it "not too long" do
        long = "this is way too looooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooong"
        msg = "Kurssiavain voi olla korkeintaan " + MAX_COURSE_KEY_LENGTH.to_s + " merkkiä pitkä."
        expect(ValidationService.validate_coursekey(long)).to eq({"error" => msg})
      end
      it "not XSS" do
        expect(ValidationService.validate_coursekey("<script>")["error"].include? "Kurssiavaimessa ei voi olla merkkejä").to eq(true)
      end
      it "not reserver" do
        @course1 = FactoryGirl.create(:course, coursekey:"key1")
        msg = {"error" => "Kurssiavain on jo varattu."}
        expect(ValidationService.validate_coursekey(@course1.coursekey)).to eq(msg)
      end
    end
    
    context "validate_coursekey(key)" do
      it "not blank" do
        msg = {"error"=>"Kurssin nimi ei voi olla tyhjä."}
        expect(ValidationService.validate_coursename(nil)).to eq(msg)
      end
      it "not too long" do
        long = "this is way too looooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooong"
        msg = "Kurssin nimi voi olla korkeintaan " + MAX_COURSE_NAME_LENGTH.to_s + " merkkiä pitkä."
        expect(ValidationService.validate_coursename(long)).to eq({"error" => msg})
      end
      it "not XSS" do
        expect(ValidationService.validate_coursename("<script>")["error"].include? "Kurssin nimessä ei voi olla merkkejä").to eq(true)
      end
      
    end
  end
  
  describe "create schedule validations" do
    context "validate_schedulename(cid, s_name)" do
      it "not blank" do
        msg = {"error" => "Tavoitteella täytyy olla nimi."}
        expect(ValidationService.validate_schedulename(1, nil)).to eq(msg)
      end
      it "not too long" do
        long = "this is way too looooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooong"
        msg = "Tavoitteen nimi voi olla korkeintaan " + MAX_SCHEDULE_NAME_LENGTH.to_s + " merkkiä pitkä."
        expect(ValidationService.validate_schedulename(1, long)).to eq({"error" => msg})
      end
      it "not XSS" do
        expect(ValidationService.validate_schedulename(1,"<script>")["error"].include? "Tavoitteen nimessä ei voi olla merkkejä").to eq(true)
      end
      it "not reserved" do
        @course1 = FactoryGirl.create(:course, coursekey:"key1")
        Schedule.create(course_id: @course1.id, name: "reserved", color: 1)
        msg = "Kahdella tavoitteella ei voi olla samaa nimeä."
        expect(ValidationService.validate_schedulename(@course1.id, "reserved")).to eq({"error" => msg})
      end
    end
  end

end
