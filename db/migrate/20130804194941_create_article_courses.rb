class CreateArticleCourses < ActiveRecord::Migration
  def change
    create_table :article_courses do |t|
      t.integer :sequence
      t.references :article
      t.references :course

      t.timestamps
    end
    add_index :article_courses, :article_id
    add_index :article_courses, :course_id
  end
end
