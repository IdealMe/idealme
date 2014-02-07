
require 'spec_helper'

describe Admin::OrdersController do
  before :each do
    sign_in user
  end

  let(:user)           { create(:user_admin) }
  let!(:order)          { create(:order) }

  describe "#index" do
    it "shows a list of orders" do
      get :index
      assigns[:orders].should eq [order]
    end
  end


end
