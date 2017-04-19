class ValidationService

  def self.validate_coursekey(key)
    if key.blank?
      return {"error" => "Kurssiavain ei voi olla tyhjä."}
    elsif key.length > MAX_COURSE_KEY_LENGTH
      msg = "Kurssiavain voi olla korkeintaan " + MAX_COURSE_KEY_LENGTH.to_s + " merkkiä pitkä."
      return {"error" => msg}
    elsif key.match(/\s/)
      return {"error" => "Kurssiavaimessa ei voi olla välilyöntiä."}
    elsif not SecurityService.safe_string?(key)
      msg = "Kurssiavaimessa ei voi olla merkkejä: "
      msg = add_bad_characters(msg)
      return {"error" => msg}
    elsif CourseService.coursekey_reserved?(key)
      return {"error" => "Kurssiavain on jo varattu."}
    else
      return nil
    end
  end
  
  def self.validate_coursename(name)
    if name.blank?
      return {"error" => "Kurssin nimi ei voi olla tyhjä."}
    elsif name.length > MAX_COURSE_NAME_LENGTH
      msg = "Kurssin nimi voi olla korkeintaan " + MAX_COURSE_NAME_LENGTH.to_s + " merkkiä pitkä."
      return {"error" => msg}
    elsif not SecurityService.safe_string?(name)
      msg = "Kurssin nimessä ei voi olla merkkejä: "
      msg = add_bad_characters(msg)
      return {"error" => msg}
    else
      return nil
    end
  end
  
  def self.validate_schedulename(cid, s_name)
    if s_name.blank?
      return {"error" => "Tavoitteella täytyy olla nimi."}
    elsif s_name.length > MAX_SCHEDULE_NAME_LENGTH
      msg = "Tavoitteen nimi voi olla korkeintaan " + MAX_SCHEDULE_NAME_LENGTH.to_s + " merkkiä pitkä."
      return {"error" => msg}
    elsif not SecurityService.safe_string?(s_name)
      msg = "Tavoitteen nimessä ei voi olla merkkejä: "
      msg = add_bad_characters(msg)
      return {"error" => msg}
    elsif ScheduleService.name_reserved?(cid, s_name)  
      return {"error" => "Kahdella tavoitteella ei voi olla samaa nimeä."}
    else
      return nil
    end
  end
  
  def self.validate_schedulecolor(color)
    if color.is_a? Integer and color > 0
      return nil
    elsif color.blank? or color.length > 2 or color.to_i < 1
      return {"error" => "Parametri color virheellinen."}
    else
      return nil
    end
  end
  
  def self.validate_course_dates(startdate, enddate)
    if startdate.blank? or enddate.blank?
      return {"error" => "Kurssilla täytyy olla alkamis- ja loppumispäivämäärät."}
    elsif startdate.length > 10 or enddate.length > 10
      return {"error" => "Muotoa 2015-01-15 oleva päivämäärä ei voi olla pidempi kuin 10 merkkiä."}
    elsif not (Date.valid_date? *startdate.split('-').map(&:to_i) rescue false) or startdate[0..3].include? "-"
      return {"error" => "Kurssin alkamispäivämäärä ei ole muodossa 2015-01-15."}
    elsif not (Date.valid_date? *enddate.split('-').map(&:to_i) rescue false) or enddate[0..3].include? "-"
      return {"error" => "Kurssin loppumispäivämäärä ei ole muodossa 2015-01-15."}
    elsif Date.parse(startdate) > Date.parse(enddate)
      return {"error" => "Alkamispäivämäärä ei voi olla loppumispäivämäärän jälkeen!"}
    else
      return nil
    end
    
  end
  
  private
    def self.add_bad_characters(msg)
      BAD_CHARACTERS.each do |c|
        msg += c
      end
      return msg
    end

end
