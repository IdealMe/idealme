require 'spec_helper'

describe "admin/feedbacks/show" do
  before(:each) do
    @admin_feedback = assign(:admin_feedback, stub_model(Admin::Feedback))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
