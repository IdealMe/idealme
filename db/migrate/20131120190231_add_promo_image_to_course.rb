class AddPromoImageToCourse < ActiveRecord::Migration
  def change
    change_table :courses do |t|
      t.attachment :image
    end
  end
end
