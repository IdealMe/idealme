class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :name
      t.string :slug
      t.text :content
      t.boolean :hidden
      t.references :category
      t.references :course
      t.references :goal
      t.integer :default_market_id

      t.timestamps
    end
    add_index :articles, :category_id
    add_index :articles, :course_id
    add_index :articles, :goal_id
    add_index :articles, :default_market_id
  end
end
