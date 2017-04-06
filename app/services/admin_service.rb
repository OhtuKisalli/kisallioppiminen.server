class AdminService

  def self.download_exercises(url)
    exercise_IDs = nil
    if url
      open(url) do |file|
	      page = file.read
	      exercise_IDs = page.scan(/<div class="tehtava"\s+id="([a-zA-Z0-9ÅåÄäÖö.;:_-]+)">/)
      end
    end
    if not exercise_IDs
      return nil
    end
    exs = []
    exercise_IDs.each do |e|
      exs << e[0]
    end
    return exs
  end

  def self.save_exercises(exercises, hid)
    elist = ExerciselistService.new_list(hid)
    create_exercises(exercises, elist.html_id)
  end
  
  def self.add_exercises(exercises, hid)
    elist = ExerciselistService.elist_id_by_html_id(hid)
    if elist
      create_exercises(exercises, hid)
    end
  end
  
  private
    def self.create_exercises(exercises, html_id)
      exercises.each do |e|
        if not ExerciseService.exercise_on_list?(html_id, e)
          ExerciseService.create_exercise(html_id, e)
        end
      end  
    end

end

