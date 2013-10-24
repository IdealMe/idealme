class CreateAffiliateLinks < ActiveRecord::Migration
  def change
    create_table :affiliate_links do |t|
      t.string :name
      t.string :slug
      t.text :note
      t.string :tracking_tag
      t.string :market_tag
      t.string :affiliate_tag
      t.references :user


      t.timestamps
    end
  end
end
