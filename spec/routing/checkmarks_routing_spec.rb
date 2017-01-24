require "rails_helper"

RSpec.describe CheckmarksController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/checkmarks").to route_to("checkmarks#index")
    end

    it "routes to #new" do
      expect(:get => "/checkmarks/new").to route_to("checkmarks#new")
    end

    it "routes to #show" do
      expect(:get => "/checkmarks/1").to route_to("checkmarks#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/checkmarks/1/edit").to route_to("checkmarks#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/checkmarks").to route_to("checkmarks#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/checkmarks/1").to route_to("checkmarks#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/checkmarks/1").to route_to("checkmarks#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/checkmarks/1").to route_to("checkmarks#destroy", :id => "1")
    end

  end
end
