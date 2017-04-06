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
    exercises.each do |e|
      ExerciseService.create_exercise(elist.html_id, e)
    end
  end

end

