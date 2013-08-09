require "spec_helper"

describe Admin::FeedbacksController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/feedbacks").should route_to("admin/feedbacks#index")
    end

    it "routes to #new" do
      get("/admin/feedbacks/new").should route_to("admin/feedbacks#new")
    end

    it "routes to #show" do
      get("/admin/feedbacks/1").should route_to("admin/feedbacks#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/feedbacks/1/edit").should route_to("admin/feedbacks#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/feedbacks").should route_to("admin/feedbacks#create")
    end

    it "routes to #update" do
      put("/admin/feedbacks/1").should route_to("admin/feedbacks#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/feedbacks/1").should route_to("admin/feedbacks#destroy", :id => "1")
    end

  end
end
