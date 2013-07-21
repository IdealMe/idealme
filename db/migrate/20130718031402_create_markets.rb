class CreateMarkets < ActiveRecord::Migration
  def change
    create_table :markets do |t|
      t.string :name
      t.string :slug
      t.string :affiliate_tag
      t.text :content
      t.boolean :hidden, :default => false
      t.boolean :slider, :default => false
      t.attachment :avatar
      t.references :course
      t.timestamps
    end

    add_index :markets, :course_id
  end
end
