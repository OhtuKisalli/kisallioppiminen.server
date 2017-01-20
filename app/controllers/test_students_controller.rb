class TestStudentsController < ApplicationController
  before_action :set_test_student, only: [:show, :edit, :update, :destroy]

  # Allows cross site JSON requests
  protect_from_forgery unless: -> { request.format.json? }

  # GET /test_students
  # GET /test_students.json
  def index
    @test_students = TestStudent.all
  end

  # GET /test_students/1
  # GET /test_students/1.json
  def show
  end

  # GET /test_students/new
  def new
    @test_student = TestStudent.new
  end

  # GET /test_students/1/edit
  def edit
  end

  # POST /test_students
  # POST /test_students.json
  def create
    @test_student = TestStudent.new(test_student_params)

    respond_to do |format|
      if @test_student.save
        format.html { redirect_to @test_student, notice: 'Test student was successfully created.' }
        format.json { render :show, status: :created, location: @test_student }
      else
        format.html { render :new }
        format.json { render json: @test_student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /test_students/1
  # PATCH/PUT /test_students/1.json
  def update
    respond_to do |format|
      if @test_student.update(test_student_params)
        format.html { redirect_to @test_student, notice: 'Test student was successfully updated.' }
        format.json { render :show, status: :ok, location: @test_student }
      else
        format.html { render :edit }
        format.json { render json: @test_student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /test_students/1
  # DELETE /test_students/1.json
  def destroy
    @test_student.destroy
    respond_to do |format|
      format.html { redirect_to test_students_url, notice: 'Test student was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_test_student
      @test_student = TestStudent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def test_student_params
      params.require(:test_student).permit(:name, :points)
    end
end
