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
        @course1 = FactoryGirl.create(:course, coursekey:"key1")
        expect(ValidationService.validate_schedulecolor(nil, @course1.id)).to eq(msg)
        expect(ValidationService.validate_schedulecolor("", @course1.id)).to eq(msg)
        expect(ValidationService.validate_schedulecolor("f", @course1.id)).to eq(msg)
        expect(ValidationService.validate_schedulecolor("ff", @course1.id)).to eq(msg)
        expect(ValidationService.validate_schedulecolor("0", @course1.id)).to eq(msg)
        expect(ValidationService.validate_schedulecolor("100", @course1.id)).to eq(msg)
        expect(ValidationService.validate_schedulecolor("<script>", @course1.id)).to eq(msg)
        expect(ValidationService.validate_schedulecolor("1", @course1.id)).to eq(nil)
        expect(ValidationService.validate_schedulecolor(1, @course1.id)).to eq(nil)
        expect(ValidationService.validate_schedulecolor(99, @course1.id)).to eq(nil)
        Schedule.create(course_id: @course1.id, name: "reserved", color: 1)
        expect(Schedule.count).to eq(1)
        expect(Schedule.last.course_id).to eq(@course1.id)
        expect(@course1.schedules.count).to eq(1)
        msg = {"error" => "Valittu väri on jo käytössä."}
        expect(ValidationService.validate_schedulecolor(1, @course1.id)).to eq(msg)
      end
    end
    context "validate_update_schedules(schedules)" do
      it "not blank" do
        msg = {"error" => "Parametri schedules on virheellinen."}
        expect(ValidationService.validate_update_schedules(nil)).to eq(msg)
      end
      it "invalid key" do
        schedules = {"1"=>{},"<scipts>"=>{},"3"=>{}}
        msg = {"error" => "Parametrissä schedules on sopimaton avain."}
        expect(ValidationService.validate_update_schedules(schedules)).to eq(msg)
      end
      it "nil when correct" do
        schedules = {"1"=>{},"22"=>{},"33"=>{}}
        expect(ValidationService.validate_update_schedules(schedules)).to eq(nil)
      end
    end
  end
  
  describe "other validations" do
    it "color validations" do
      expect(ValidationService.validate_color(VALID_COLOR_NAMES.sample, "Color")).to eq(nil)
      expect(ValidationService.validate_color(nil, "Color")).to eq({"error" => "Color ei voi olla tyhjä."})
      expect(ValidationService.validate_color("purple!", "Color")["error"].include? "Color ei kuulu joukkoon").to eq(true)
    end
    it "string_valid_uuid?(param)" do
      expect(ValidationService.string_valid_uuid?(nil)).to eq(false)
      expect(ValidationService.string_valid_uuid?("gg")).to eq(false)
      expect(ValidationService.string_valid_uuid?("1fc58dcb-7cad-4bc8-b7d9-f521dc4f40f9")).to eq(true)
      expect(ValidationService.string_valid_uuid?("1fc58dcb-7cad-4bc8-b7d9-f521dc4f40f!")).to eq(false)
      expect(ValidationService.string_valid_uuid?("1fc58dcb-7cad-4bc8-b7d9-f521dc4f40f91")).to eq(false)
      expect(ValidationService.string_valid_uuid?("1fc58dcb_7cad-4bc8-b7d9-f521dc4f40f9")).to eq(false)
    end
    it "not_valid_exercises(exercises)" do
      expect(ValidationService.not_valid_exercises(nil)).to eq([])
      exs = ["07454978-28f7-47da-946b-7ead4134d7e3","404f1e97-04c4-46ed-8f6f-98c5e6f63adb"]
      expect(ValidationService.not_valid_exercises(exs)).to eq([])
      not_valid = "07454978-28f7-47da-946b!7ead4134d7e3"
      exs << not_valid
      expect(ValidationService.not_valid_exercises(exs)).to eq([not_valid])
    end
    
  end

end
