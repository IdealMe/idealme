class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.string :name
      t.string :slug
      t.text :content
      t.references :course

      t.timestamps
    end
    add_index :sections, :course_id
  end
end