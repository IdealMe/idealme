require 'spec_helper'

describe "admin/feedbacks/index" do
  before(:each) do
    assign(:admin_feedbacks, [
      stub_model(Admin::Feedback),
      stub_model(Admin::Feedback)
    ])
  end

  it "renders a list of admin/feedbacks" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
