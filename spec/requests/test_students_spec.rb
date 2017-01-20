require 'rails_helper'

RSpec.describe "TestStudents", type: :request do
  describe "GET /test_students" do
    it "works! (now write some real specs)" do
      get test_students_path
      expect(response).to have_http_status(200)
    end
  end
end
