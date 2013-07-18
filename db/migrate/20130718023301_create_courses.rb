class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.string :slug
      t.boolean :hidden, :default => true
      t.attachment :avatar

      t.timestamps
    end
  end
end