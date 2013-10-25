class MarketFeature < ActiveRecord::Base
  attr_accessible :description, :avatar, :market_id

  belongs_to :market

  has_attached_file :avatar,
                    :styles => {:thumb => '40x40#', :square => '120x120#'},
                    :convert_options => {
                      :thumb => '-gravity center -extent 40x40 -quality 75 -strip',
                      :square => '-gravity center -extent 120x120 -quality 75 -strip',
                    }

end
