class SavedJewel < ActiveRecord::Base
  belongs_to :jewel
  belongs_to :user
end
