class ChangeAffiliateLinks < ActiveRecord::Migration
  def change
    change_column :affiliate_links, :slug, :string, :unique => true
    add_index :affiliate_links, :slug, unique: true

    drop_table :affiliate_trackings
  end
end
