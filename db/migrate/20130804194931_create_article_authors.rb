class CreateArticleAuthors < ActiveRecord::Migration
  def change
    create_table :article_authors do |t|
      t.integer :author_id
      t.references :article

      t.timestamps
    end
    add_index :article_authors, :author_id
    add_index :article_authors, :article_id
  end
end
