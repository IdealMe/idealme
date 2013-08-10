require 'spec_helper'

describe Market do
  it 'has a valid factory' do
    build(:market).should be_valid
  end

  it 'is invalid without a proper name' do
    build(:market, {:name => nil}).should_not be_valid
    build(:market, {:name => ''}).should_not be_valid
  end
end
