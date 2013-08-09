require 'spec_helper'

describe "admin/feedbacks/edit" do
  before(:each) do
    @admin_feedback = assign(:admin_feedback, stub_model(Admin::Feedback))
  end

  it "renders the edit admin_feedback form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", admin_feedback_path(@admin_feedback), "post" do
    end
  end
end
