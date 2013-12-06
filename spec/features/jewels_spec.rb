require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

describe 'idealme gems' do
  let!(:user)               { create(:user) }
  let!(:goal)               { create(:goal) }

  before :each do
    Warden.test_reset!
  end

  it "goals have related gems", js: true do
    login_as user, scope: :user
    Goal.count.should eq 1

  end
end

