require 'rails_helper'

RSpec.describe TestStudentsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # TestStudent. As you add validations to TestStudent, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { {name:"Anna", points:123} }


  let(:invalid_attributes) { {name:321}  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # TestStudentsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all test_students as @test_students" do
      test_student = TestStudent.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:test_students)).to eq([test_student])
    end
  end

  describe "GET #show" do
    it "assigns the requested test_student as @test_student" do
      test_student = TestStudent.create! valid_attributes
      get :show, params: {id: test_student.to_param}, session: valid_session
      expect(assigns(:test_student)).to eq(test_student)
    end
  end

  describe "GET #new" do
    it "assigns a new test_student as @test_student" do
      get :new, params: {}, session: valid_session
      expect(assigns(:test_student)).to be_a_new(TestStudent)
    end
  end

  describe "GET #edit" do
    it "assigns the requested test_student as @test_student" do
      test_student = TestStudent.create! valid_attributes
      get :edit, params: {id: test_student.to_param}, session: valid_session
      expect(assigns(:test_student)).to eq(test_student)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new TestStudent" do
        expect {
          post :create, params: {test_student: valid_attributes}, session: valid_session
        }.to change(TestStudent, :count).by(1)
      end

      it "assigns a newly created test_student as @test_student" do
        post :create, params: {test_student: valid_attributes}, session: valid_session
        expect(assigns(:test_student)).to be_a(TestStudent)
        expect(assigns(:test_student)).to be_persisted
      end

      it "redirects to the created test_student" do
        post :create, params: {test_student: valid_attributes}, session: valid_session
        expect(response).to redirect_to(TestStudent.last)
      end
    end


  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {{ name:"Sanna", points:321}}


      it "updates the requested test_student" do
        test_student = TestStudent.create! valid_attributes
        put :update, params: {id: test_student.to_param, test_student: new_attributes}, session: valid_session
        test_student.reload
        expect(test_student.name).to match("Sanna")
      end

      it "assigns the requested test_student as @test_student" do
        test_student = TestStudent.create! valid_attributes
        put :update, params: {id: test_student.to_param, test_student: valid_attributes}, session: valid_session
        expect(assigns(:test_student)).to eq(test_student)
      end

      it "redirects to the test_student" do
        test_student = TestStudent.create! valid_attributes
        put :update, params: {id: test_student.to_param, test_student: valid_attributes}, session: valid_session
        expect(response).to redirect_to(test_student)
      end
    end


  end

  describe "DELETE #destroy" do
    it "destroys the requested test_student" do
      test_student = TestStudent.create! valid_attributes
      expect {
        delete :destroy, params: {id: test_student.to_param}, session: valid_session
      }.to change(TestStudent, :count).by(-1)
    end

    it "redirects to the test_students list" do
      test_student = TestStudent.create! valid_attributes
      delete :destroy, params: {id: test_student.to_param}, session: valid_session
      expect(response).to redirect_to(test_students_url)
    end
  end

end
