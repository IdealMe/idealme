require 'spec_helper'

describe "admin/feedbacks/new" do
  before(:each) do
    assign(:admin_feedback, stub_model(Admin::Feedback).as_new_record)
  end

  it "renders new admin_feedback form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", admin_feedbacks_path, "post" do
    end
  end
end
