class CreateJewels < ActiveRecord::Migration
  def change
    create_table :jewels do |t|
      t.string :name
      t.string :slug
      t.test :content
      t.text :url
      t.attachment :avatar
      t.integer :owner_id
      t.timestamps
    end
    add_index :jewels, :owner_id
  end
end
