class CheckmarksController < ApplicationController
  before_action :set_checkmark, only: [:destroy]

  protect_from_forgery unless: -> { request.format.json? }

  # GET /checkmarks
  def index
    @checkmarks = Checkmark.all
  end
  
  # POST /checkmarks.json
  def mark
    @checkmark = Checkmark.find_by(params.require(:checkmark).permit(:user_id, :exercise_id))
    if @checkmark.nil?
      @checkmark = Checkmark.new(checkmark_params)
    else
      @checkmark.status = params[:checkmark][:status]
    end
    respond_to do |format|
      if @checkmark.save 
        format.json { render json: @checkmark, status: :ok }
      else
        format.json { render json: @checkmark, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /checkmarks/1
  # DELETE /checkmarks/1.json
  def destroy
    @checkmark.destroy
    respond_to do |format|
      format.html { redirect_to checkmarks_url, notice: 'Checkmark was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_checkmark
      @checkmark = Checkmark.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def checkmark_params
      params.require(:checkmark).permit(:user_id, :exercise_id, :status)
    end
end
