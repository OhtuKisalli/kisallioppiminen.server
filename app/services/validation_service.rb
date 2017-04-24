class ValidationService

  def self.validate_coursekey(key)
    if key.blank?
      return {"error" => "Kurssiavain ei voi olla tyhjä."}
    elsif key.length > MAX_COURSE_KEY_LENGTH
      return {"error" => max_length_string("Kurssiavain", MAX_COURSE_KEY_LENGTH.to_s)}
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
      return {"error" => max_length_string("Kurssin nimi", MAX_COURSE_NAME_LENGTH.to_s)}
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
      return {"error" => max_length_string("Tavoitteen nimi", MAX_SCHEDULE_NAME_LENGTH.to_s)}
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
  
  def self.validate_schedulecolor(color, cid)
    if ScheduleService.color_reserved?(cid, color)
      return {"error" => "Valittu väri on jo käytössä."}
    elsif color.is_a? Integer and color > 0
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
  
  def self.validate_color(param, name)
    if param.blank? 
      return {"error" => "#{name} ei voi olla tyhjä."}
    elsif not (VALID_COLOR_NAMES.include? param)
      msg = "#{name} ei kuulu joukkoon " + VALID_COLOR_NAMES.to_s
      return {"error" => msg}
    else
      return nil
    end
  end
  
  def self.validate_update_schedules(schedules)
    if schedules.blank?
      return {"error" => "Parametri schedules on virheellinen."}
    end
    schedules.keys.each do |key|
      if not (key !~ /\D/)
        return {"error" => "Parametrissä schedules on sopimaton avain."}  
      end
    end
    return nil    
  end
  
  def self.string_valid_uuid?(param)
    if param.blank? or param.length != 36 or not param =~ /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/
      return false
    end
    return true
  end
  
  def self.not_valid_exercises(exercises)
    if exercises.blank?
      return []
    end
    exs = []
    exercises.each do |e|
      if not string_valid_uuid?(e)
        exs << e
      end
    end
    return exs
  end
  
  private
    def self.max_length_string(what, howlong)
      return what + " voi olla korkeintaan " + howlong + " merkkiä pitkä."
    end
  
    def self.add_bad_characters(msg)
      BAD_CHARACTERS.each do |c|
        msg += c
      end
      return msg
    end

end
