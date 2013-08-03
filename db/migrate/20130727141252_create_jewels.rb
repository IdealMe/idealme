class CreateJewels < ActiveRecord::Migration
  def change
    create_table :jewels do |t|
      t.string :name
      t.string :slug
      t.integer :up_votes, :default => 0
      t.integer :down_votes, :default => 0
      t.text :content
      t.text :url
      t.text :parameters
      t.attachment :avatar
      t.integer :owner_id
      t.integer :kind
      t.references :goal
      t.references :course
      t.timestamps
    end
    add_index :jewels, :owner_id
  end
end
