require 'spec_helper'

describe Goal do
  it 'has a valid factory' do
    build(:goal).should be_valid
  end

  it 'is invalid without a proper name' do
    build(:goal, {name: nil}).should_not be_valid
    build(:goal, {name: ''}).should_not be_valid
  end
end
