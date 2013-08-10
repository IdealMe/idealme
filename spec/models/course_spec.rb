require 'spec_helper'

describe Course do
  it 'has a valid factory' do
    build(:course).should be_valid
  end

  it 'is invalid without a proper name' do
    build(:course, {:name => nil}).should_not be_valid
    build(:course, {:name => ''}).should_not be_valid
  end

  it 'is invalid without a proper cost' do
    build(:course, {:cost => nil}).should_not be_valid
    build(:course, {:cost => -1}).should_not be_valid
    build(:course, {:cost => 1_000_000}).should_not be_valid
  end
end
