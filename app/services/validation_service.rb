class ValidationService

  def self.validate_coursekey(key)
    if key.blank?
      return {"error" => "Kurssiavain ei voi olla tyhjä."}
    elsif key.length > MAX_COURSE_KEY_LENGTH
      msg = "Kurssiavain voi olla korkeintaan " + MAX_COURSE_KEY_LENGTH.to_s + " merkkiä pitkä."
      return {"error" => msg}
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
  
  private
    def self.add_bad_characters(msg)
      BAD_CHARACTERS.each do |c|
        msg += c
      end
      return msg
    end

end
