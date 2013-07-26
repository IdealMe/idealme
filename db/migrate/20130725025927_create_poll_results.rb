class CreatePollResults < ActiveRecord::Migration
  def change
    create_table :poll_results do |t|
      t.references :poll_question
      t.references :poll_choice
      t.integer :owner_id

      t.timestamps
    end
    add_index :poll_results, :poll_question_id
    add_index :poll_results, :poll_choice_id
    add_index :poll_results, :owner_id
  end
end
