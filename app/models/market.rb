class Market < ActiveRecord::Base
  attr_accessible :avatar, :hidden, :name, :slug


  has_attached_file :avatar,
                    :styles => {:full => '252x202#'},
                    :convert_options => {
                        :full => '-background black -gravity center -extent 252x202 -quality 75 -strip',
                    }
end
