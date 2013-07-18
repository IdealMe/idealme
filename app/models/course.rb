class Course < ActiveRecord::Base
  attr_accessible :avatar, :hidden, :name, :slug
end
