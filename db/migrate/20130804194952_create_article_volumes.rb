class CreateArticleVolumes < ActiveRecord::Migration
  def change
    create_table :article_volumes do |t|
      t.integer :article_source_id
      t.integer :article_target_id
      t.integer :sequence
      t.timestamps
    end
    add_index :article_volumes, :article_source_id
    add_index :article_volumes, :article_target_id
  end
end
