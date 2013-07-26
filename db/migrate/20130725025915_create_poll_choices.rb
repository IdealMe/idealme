class CreatePollChoices < ActiveRecord::Migration
  def change
    create_table :poll_choices do |t|
      t.string :name
      t.references :poll_question

      t.timestamps
    end
    add_index :poll_choices, :poll_question_id
  end
end
