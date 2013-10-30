class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.references :commentable, polymorphic: true
      t.integer :owner_id

      t.timestamps
    end
  end
end
