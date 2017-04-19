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
      it "no whitespace" do
        msg = {"error" => "Kurssiavaimessa ei voi olla välilyöntiä."}
        expect(ValidationService.validate_coursekey("keykey ")).to eq(msg)
        expect(ValidationService.validate_coursekey("key key")).to eq(msg)
      end
    end
    
    context "validate_coursename(name)" do
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
    
    context "validate_course_dates(startdate, enddate)" do
      it "not blank" do
        msg = {"error" => "Kurssilla täytyy olla alkamis- ja loppumispäivämäärät."}
        expect(ValidationService.validate_course_dates("", "2015-01-11")).to eq(msg)
        expect(ValidationService.validate_course_dates("2015-01-11", nil)).to eq(msg)
        expect(ValidationService.validate_course_dates(nil, "")).to eq(msg)
      end
      it "not too long" do
        msg = {"error" => "Muotoa 2015-01-15 oleva päivämäärä ei voi olla pidempi kuin 10 merkkiä."}
        expect(ValidationService.validate_course_dates('<script>alert("Hohoho");</script>', "2015-01-11")).to eq(msg)
        expect(ValidationService.validate_course_dates("2015-01-11", "2015-01-11-")).to eq(msg)
      end
      it "format not correct" do
        msg = {"error" => "Kurssin alkamispäivämäärä ei ole muodossa 2015-01-15."}
        expect(ValidationService.validate_course_dates("01-01h20h1", "2015-01-11")).to eq(msg)
        msg = {"error" => "Kurssin loppumispäivämäärä ei ole muodossa 2015-01-15."}
        expect(ValidationService.validate_course_dates("2015-01-11", "2015-01ehf")).to eq(msg)
      end
      it "startdate not after enddate" do
        msg = {"error" => "Alkamispäivämäärä ei voi olla loppumispäivämäärän jälkeen!"}
        expect(ValidationService.validate_course_dates("2015-01-12", "2015-01-11")).to eq(msg)
        expect(ValidationService.validate_course_dates("2016-01-12", "2015-01-12")).to eq(msg)
      end
      it "works when input correct" do
        expect(ValidationService.validate_course_dates("2015-01-12", "2015-01-12")).to eq(nil)
        expect(ValidationService.validate_course_dates("2015-01-12", "2015-01-13")).to eq(nil)
        expect(ValidationService.validate_course_dates("2015-01-12", "2016-02-12")).to eq(nil)
        expect(ValidationService.validate_course_dates("2015-09-12", "2015-10-01")).to eq(nil)
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
    context "validate_schedulecolor(color)" do
      it "not integer 1..99" do
        msg = {"error" => "Parametri color virheellinen."}
        expect(ValidationService.validate_schedulecolor(nil)).to eq(msg)
        expect(ValidationService.validate_schedulecolor("")).to eq(msg)
        expect(ValidationService.validate_schedulecolor("f")).to eq(msg)
        expect(ValidationService.validate_schedulecolor("ff")).to eq(msg)
        expect(ValidationService.validate_schedulecolor("0")).to eq(msg)
        expect(ValidationService.validate_schedulecolor("100")).to eq(msg)
        expect(ValidationService.validate_schedulecolor("<script>")).to eq(msg)
        expect(ValidationService.validate_schedulecolor("1")).to eq(nil)
        expect(ValidationService.validate_schedulecolor(1)).to eq(nil)
        expect(ValidationService.validate_schedulecolor(99)).to eq(nil)
      end
    end
  end
  
  describe "other validations" do
    it "color validations" do
      expect(ValidationService.validate_color(VALID_COLOR_NAMES.sample, "Color")).to eq(nil)
      expect(ValidationService.validate_color(nil, "Color")).to eq({"error" => "Color ei voi olla tyhjä."})
      expect(ValidationService.validate_color("purple!", "Color")["error"].include? "Color ei kuulu joukkoon").to eq(true)
    end
  end

end
