require "spec_helper"

describe UserMailer do
  describe "welcome" do
    let(:mail) { UserMailer.welcome(user) }
    let(:user) { create(:user) }

    it "renders the headers" do
      mail.subject.should eq("Welcome")
      mail.to.should eq([user.email])
      mail.from.should eq(["info@idealme.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
