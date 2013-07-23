class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.text :content
      t.boolean :recommended, :default => true
      t.integer :owner_id
      t.references :course

      t.timestamps
    end
    add_index :reviews, :course_id
    add_index :reviews, :owner_id
  end
end
