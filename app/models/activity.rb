class Activity < ActiveRecord::Base
  serialize :parameters

  attr_accessible :action, :count, :key, :parameters, :read
end
