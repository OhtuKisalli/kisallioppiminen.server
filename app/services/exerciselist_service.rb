class ExerciselistService

  # returns nil or id
  def self.elist_id_by_html_id(hid)
    elist = Exerciselist.where(html_id: hid).first
    if not elist
      return nil
    end
    return elist.id
  end
  
  #
  def self.all_exerciselists
    return Exerciselist.all
  end
  
  #
  def self.delete(id)
    return Exerciselist.delete(id)
  end
  
  #
  def self.new_list(html_id)
    if elist_id_by_html_id(html_id)
      return nil
    else
      return Exerciselist.create(html_id: html_id)
    end
  end

  # returns [] or nil
  def self.exercises_by_html_id(hid)
    elist = Exerciselist.where(html_id: hid).first
    if not elist
      return nil
    end
    return elist.exercises.map(&:html_id)
  end

end
