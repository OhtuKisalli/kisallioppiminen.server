require 'rails_helper'

RSpec.describe CoursesController, type: :controller do

  let(:valid_attributes) { {html_id: "exampleHtmlId", coursekey:"examplekey", name:"matikka1"} }


  let(:invalid_attributes) { {name:321}  }

  let(:valid_session) { {} }

  describe "Create" do
    it "creates new Course with valid params" do
      course = Course.create! valid_attributes
      expect(Course.count).to eq(1)
    end

    #Ilmeisesti luo myös invalid parametreillä?
    #it "doesn't create with invalid params" do
    #  course2 = Course.create invalid_attributes
    #  expect(course2.name).to match("examplekey")
    #end

  end

  describe "GET #new" do
    it "assigns a new course as @course" do
      get :new, params: {}, session: valid_session
      expect(assigns(:course)).to be_a_new(Course)
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {{html_id: "exampleHtmlId", coursekey:"NEWkey", name:"matikka1"}}


      #it "updates the requested course" do
      #  course = Course.create! valid_attributes
      #  put :update, params: {id: course.to_param, course: new_attributes}, session: valid_session
      #  course.reload
      #  expect(course.coursekey).to match("NEWkey")
      #end

      it "assigns the requested course as @course" do
        course = Course.create! valid_attributes
        put :update, params: {id: course.to_param, course: valid_attributes}, session: valid_session
        expect(assigns(:course)).to eq(course)
      end

    end

  end

  describe "DELETE #destroy" do
    it "destroys the requested course" do
      course = Course.create! valid_attributes
      expect {
        delete :destroy, params: {id: course.to_param}, session: valid_session
      }.to change(Course, :count).by(-1)
    end

    it "destroys courses exercises" do
      course = Course.create! valid_attributes
      exercise = Exercise.create html_id: "exerc_htmlId", name: "testexercise", course_id: course.id
      expect {
        delete :destroy, params: {id: course.to_param}, session: valid_session
      }.to change(Exercise, :count).by(-1)
    end
  end

end
