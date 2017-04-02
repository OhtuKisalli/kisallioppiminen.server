class ExerciselistService

  # returns nil or id
  def self.elist_id_by_html_id(hid)
    elist = Exerciselist.where(html_id: hid).first
    if not elist
      return nil
    end
    return elist.id
  end

end
