class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.string :slug
      t.integer :cost

      t.integer :owner_id

      t.attachment :avatar
      t.timestamps
    end
    add_index :courses, :owner_id
  end
end
