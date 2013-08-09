class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.integer :feedback_type, :default => Feedback::GENERAL_FEEDBACK
      t.integer :owner_id
      t.text :content

      t.timestamps
    end
    add_index :feedbacks, :owner_id
  end
end
