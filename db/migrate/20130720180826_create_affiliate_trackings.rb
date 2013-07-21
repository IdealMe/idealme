class CreateAffiliateTrackings < ActiveRecord::Migration
  def change
    create_table :affiliate_trackings do |t|
      t.string :name
      t.string :slug
      t.text :note
      t.string :affiliate_tag
      t.references :user

      t.timestamps
    end
    add_index :affiliate_trackings, :user_id
  end
end
