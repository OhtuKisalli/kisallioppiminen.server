require 'rails_helper'

RSpec.describe ExercisesController, type: :controller do
  let(:course){ FactoryGirl.create(:Course) }

  let(:valid_attributes) { {html_id: "exerciseHtmlId", name:"exercise1.1", course_id: course.id} }

  let(:invalid_attributes) { {name:321}  }

  let(:valid_session) { {} }


  describe "GET #new" do
    it "assigns a new exercise as @exercise" do

      exercise = Exercise.create! html_id: "exerciseHtmlId", name:"exercise1.1", course_id: course.id

      expect(exercise.name).to match("exercise1.1")
    end
  end

  describe "Create new" do
    it "with valid params creates new exercise" do
      expect(Exercise.count).to eq(0)
      exercise = Exercise.create! valid_attributes

      expect(Exercise.count).to be(1)
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {{html_id: "exerciseHtmlId", name:"exercise2.1", course_id: course.id}}


      it "updates the requested course" do
        exercise = Exercise.create! valid_attributes
        put :update, params: {id: exercise.to_param, exercise: new_attributes}, session: valid_session
        exercise.reload
        expect(exercise.name).to match("exercise2.1")
      end

      it "assigns the requested exercise as @exercise" do
        exercise = Exercise.create! valid_attributes
        put :update, params: {id: exercise.to_param, exercise: valid_attributes}, session: valid_session
        expect(assigns(:exercise)).to eq(exercise)
      end

    end

  end

  describe "DELETE #destroy" do
    it "destroys the requested exercise" do
      exercise = Exercise.create! valid_attributes
      expect {
        delete :destroy, params: {id: exercise.to_param}, session: valid_session
      }.to change(Exercise, :count).by(-1)
    end

    #Tää ei hyväksynyt checkmarkin html_id:tä, pitää selvittää
    #it "destroys exercises checkmarks" do
    #  exercise = Exercise.create! valid_attributes
    #  user = FactoryGirl.create(:User)
    #  checkmark = Checkmark.create user_id: user.id, html_id: "checks_html", coursekey: course.coursekey, status: "yellow"
    #  expect {
    #    delete :destroy, params: {id: exercise.to_param}, session: valid_session
    #  }.to change(Checkmark, :count).by(-1)
    #end
  end


end
