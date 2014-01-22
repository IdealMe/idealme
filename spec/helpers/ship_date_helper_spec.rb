require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the ShipDateHelper. For example:
#
# describe ShipDateHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
describe ShipDateHelper do
  describe "next_delivery_date" do
    it "returns the closest business date 2 days from current" do
      ndd = helper.next_delivery_date(Date.new(2014,1,24))
      expect(ndd).to eq Date.new(2014,1,28)

      ndd = helper.next_delivery_date(Date.new(2014,1,21))
      expect(ndd).to eq Date.new(2014,1,23)
    end

  end
end
