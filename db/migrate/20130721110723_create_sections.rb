class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.string :name
      t.string :slug
      
      t.text :description
      t.text :content
      
      t.references :course

      t.integer :position, :default => 0

      t.timestamps
    end
    add_index :sections, :course_id
  end
end