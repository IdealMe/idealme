require 'spec_helper'

describe Market do
  it 'has a valid factory' do
    build(:market).should be_valid
  end

  it 'is invalid without a proper name' do
    build(:market, {:name => nil}).should_not be_valid
    build(:market, {:name => ''}).should_not be_valid
  end

  it 'can have features' do
    market = create(:market)
    feature = MarketFeature.create(market_id: market.id, description: 'Super awesome feature')
    expect(market.reload.features.count).to eq 1
  end

  it 'rejects blank features' do
    market = create(:market)
    market.features.build
    market.features.build
    expect(market.reload.features.count).to eq 0
  end
end
