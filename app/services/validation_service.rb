class ValidationService

  def self.validate_coursekey(key)
    if key.blank?
      return {"error" => "Kurssiavain ei voi olla tyhjä."}
    elsif key.length > MAX_COURSE_KEY_LENGTH
      msg = "Kurssiavain voi olla korkeintaan " + MAX_COURSE_KEY_LENGTH.to_s + " merkkiä pitkä."
      return {"error" => msg}
    elsif not SecurityService.safe_string?(key)
      msg = "Kurssiavaimessa ei voi olla merkkejä: "
      BAD_CHARACTERS.each do |c|
        msg += c
      end
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
      BAD_CHARACTERS.each do |c|
        msg += c
      end
      return {"error" => msg}
    else
      return nil
    end
  end

end
