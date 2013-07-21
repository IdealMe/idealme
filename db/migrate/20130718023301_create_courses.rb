class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.string :slug
      t.integer :cost

      t.integer :owner_id

      t.boolean :hidden, :default => false
      t.text :google_conversion_tracking
      t.decimal :affiliate_commission, :precision => 6, :scale => 3, :default => 50

      t.integer :default_market_id

      t.attachment :avatar
      t.timestamps
    end
    add_index :courses, :owner_id
    add_index :courses, :default_market_id
  end
end
