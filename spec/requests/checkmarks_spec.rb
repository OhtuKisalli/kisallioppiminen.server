require 'rails_helper'

RSpec.describe "Checkmarks", type: :request do
  describe "GET /checkmarks" do
    it "works! (now write some real specs)" do
      get checkmarks_path
      expect(response).to have_http_status(200)
    end
  end
end
