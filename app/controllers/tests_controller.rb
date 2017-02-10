class TestsController < ApplicationController

  protect_from_forgery unless: -> { request.format.json? }

  # POST /test/json
  def jsontest
    render :json => params
  end
  
  # GET /test/idtest
  def idtest
    exercise_IDs = nil
    open("https://ohtukisalli.github.io/kurssit/may1/print.html") do |file|
	    page = file.read
	    exercise_IDs = page.scan(/<div class="tehtava"\s+id="([a-zA-Z0-9ÅåÄäÖö.;:_-]+)">/)
    end
    # render :json => exercise_IDs[0][0] #name
    render :json => exercise_IDs
  end
  
  # POST /test/idtest2 
  def idtest2
    url = params[:url]
    if url
      exercise_IDs = nil
      open(url) do |file|
	      page = file.read
	      exercise_IDs = page.scan(/<div class="tehtava"\s+id="([a-zA-Z0-9ÅåÄäÖö.;:_-]+)">/)
      end
      render :json => exercise_IDs
    else
      render :json => {}
    end 
  end
  
end

