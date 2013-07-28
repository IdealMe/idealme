class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.text :content
      t.references :comment
      t.integer :owner_id

      t.timestamps
    end
    add_index :replies, :comment_id
  end
end
