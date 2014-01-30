
require 'spec_helper'

describe Article do

  describe "#goals=" do
    let(:article) { Article.create(name: "test article", content: "test content") }
    let(:goal)    { create(:goal) }
    it "sets multiple article goals for article" do
      article.goals = ['', '', goal.id]
      article.goals.should eq [goal]
    end
  end
end
