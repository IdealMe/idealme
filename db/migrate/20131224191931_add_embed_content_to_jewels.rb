class AddEmbedContentToJewels < ActiveRecord::Migration
  def change
    add_column :jewels, :embed_content, :text
  end
end
