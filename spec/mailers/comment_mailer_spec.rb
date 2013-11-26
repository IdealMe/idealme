require "spec_helper"

describe CommentMailer do
  describe "question" do
    let!(:course) { create(:course, owner_id: affiliate_user.id) }
    let!(:user)   { create(:user) }
    let!(:affiliate_user)   { create(:affiliate_user) }
    let!(:comment) { create(:comment, commentable: course) }
    let!(:mail)   { CommentMailer.question(course, user, "I got a question", comment.id) }

    it "renders the headers" do
      mail.subject.should eq("Question")
      mail.to.should eq([course.owner.email, 'questions@idealme.com'])
      mail.from.should eq(["#{course.slug}+#{comment.id}@questions.idealme.com"])
    end

    it "renders the body" do
      mail.body.encoded.should include("I got a question")
    end
  end

end
