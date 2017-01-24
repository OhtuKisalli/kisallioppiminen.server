class CheckmarksController < ApplicationController
  before_action :set_checkmark, only: [:show, :edit, :update, :destroy]

  protect_from_forgery unless: -> { request.format.json? }

  # GET /checkmarks
  # GET /checkmarks.json
  def index
    @checkmarks = Checkmark.all
  end

  # GET /checkmarks/1
  # GET /checkmarks/1.json
  def show
  end

  # GET /checkmarks/new
  def new
    @checkmark = Checkmark.new
  end

  # GET /checkmarks/1/edit
  def edit
  end

  # POST /checkmarks
  # POST /checkmarks.json
  def create
    @checkmark = Checkmark.new(checkmark_params)

    respond_to do |format|
      if @checkmark.save
        format.html { redirect_to @checkmark, notice: 'Checkmark was successfully created.' }
        format.json { render :show, status: :created, location: @checkmark }
      else
        format.html { render :new }
        format.json { render json: @checkmark.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /checkmarks/1
  # PATCH/PUT /checkmarks/1.json
  def update
    respond_to do |format|
      if @checkmark.update(checkmark_params)
        format.html { redirect_to @checkmark, notice: 'Checkmark was successfully updated.' }
        format.json { render :show, status: :ok, location: @checkmark }
      else
        format.html { render :edit }
        format.json { render json: @checkmark.errors, status: :unprocessable_entity }
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
