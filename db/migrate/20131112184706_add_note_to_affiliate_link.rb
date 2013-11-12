class AddNoteToAffiliateLink < ActiveRecord::Migration
  def change
    add_column :affiliate_links, :note, :text
    add_column :affiliate_links, :name, :string
  end
end
