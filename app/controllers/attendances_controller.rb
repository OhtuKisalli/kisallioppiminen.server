class AttendancesController < ApplicationController
  before_action :set_attendance, only: [:show, :edit, :update, :destroy]

  protect_from_forgery unless: -> { request.format.json? }

  # GET /attendances
  # GET /attendances.json
  def index
    @attendances = Attendance.all
  end

  # GET /attendances/1
  # GET /attendances/1.json
  def show
  end

  # GET /attendances/new
  def new
    @attendance = Attendance.new
  end

  # GET /attendances/1/edit
  def edit
  end

  # POST /attendances
  # POST /attendances.json
  def create
    @attendance = Attendance.new(attendance_params)

    respond_to do |format|
      if @attendance.save
        format.html { redirect_to @attendance, notice: 'Attendance was successfully created.' }
        format.json { render :show, status: :created, location: @attendance }
      else
        format.html { render :new }
        format.json { render json: @attendance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /attendances/1
  # PATCH/PUT /attendances/1.json
  def update
    respond_to do |format|
      if @attendance.update(attendance_params)
        format.html { redirect_to @attendance, notice: 'Attendance was successfully updated.' }
        format.json { render :show, status: :ok, location: @attendance }
      else
        format.html { render :edit }
        format.json { render json: @attendance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attendances/1
  # DELETE /attendances/1.json
  def destroy
    @attendance.destroy
    respond_to do |format|
      format.html { redirect_to attendances_url, notice: 'Attendance was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  #Student – I can join a specific course using a coursekeys
  def newstudent
    @course = Course.where(coursekey: params[:coursekey]).first
    if not user_signed_in?
      render :json => {"error" => "Sinun täytyy ensin kirjautua sisään."}, status: 401
    elsif @course
      if Attendance.where(user_id: current_user.id, course_id: @course.id).any?
        render :json => {"error" => "Olet jo liittynyt kyseiselle kurssille."}, status: 403  
      else
        Attendance.create(user_id: current_user.id, course_id: @course.id)
        @courses = current_user.courses
        kurssit = {}
        @courses.each do |c|
          courseinfo = {}
          courseinfo["coursename"] = c.name
          courseinfo["html_id"] = c.html_id
          courseinfo["startdate"] = c.startdate
          courseinfo["enddate"] = c.enddate
          kurssit[c.coursekey] = courseinfo
        end
        render :json => {"message" => "Ilmoittautuminen tallennettu.", "courses" => kurssit}, status: 200
      end
    else
      render :json => {"error" => "Kurssia ei löydy tietokannasta."}, status: 403
    end
  end
  
  def toggle_archived
    sid = params[:sid]
    cid = params[:cid]
    if not user_signed_in?
      render :json => {"error" => "Sinun täytyy ensin kirjautua sisään."}, status: 401
    elsif sid.to_i != current_user.id
      render :json => {"error" => "Voit muuttaa vain omien kurssiesi asetuksia."}, status: 401
    elsif Attendance.where(user_id: sid, course_id: cid).empty?
      render :json => {"error" => "Et ole opiskelijana kyseisellä kurssilla."}, status: 403
    elsif params[:archived] == "true" or params[:archived] == "false"
      a = Attendance.where(user_id: sid, course_id: cid).first    
      if params[:archived] == "false"
        a.archived = false
        a.save
        render :json => {"message" => "Kurssi palautettu arkistosta."}, status: 200
      else
        a.archived = true
        a.save  
        render :json => {"message" => "Kurssi arkistoitu."}, status: 200
      end
    else 
      render :json => {"error" => "Arkistointitiedon muuttaminen ei onnistunut."}, status: 422
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attendance
      @attendance = Attendance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def attendance_params
      params.require(:attendance).permit(:user_id, :course_id)
    end
end
