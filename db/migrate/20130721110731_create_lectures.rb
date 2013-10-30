class CreateLectures < ActiveRecord::Migration
  def change
    create_table :lectures do |t|
      t.string :name
      t.string :slug

      t.text :description
      t.text :content

      t.integer :position, default: 0

      t.references :section

      t.timestamps
    end
    add_index :lectures, :section_id
  end
end
