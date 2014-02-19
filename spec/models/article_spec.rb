
require 'spec_helper'

describe Article do

  describe "#goals=" do
    let(:article) { Article.create(name: "test article", content: "test content") }
    let(:goal)    { create(:goal) }
    it "sets multiple article goals for article" do
      article.goals = ['', '', goal.id]
      article.goals.should eq [goal]
    end

    it "has a drip_content boolean" do
      article.drip_content = true
      expect(article.drip_content?).to eq true
    end

    it "has a reveal_after_days column" do
      article.reveal_after_days = 7
      expect(article.reveal_after_days).to eq 7
    end
  end
end
