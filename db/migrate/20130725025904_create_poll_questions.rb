class CreatePollQuestions < ActiveRecord::Migration
  def change
    create_table :poll_questions do |t|
      t.string :name
      t.boolean :display_results, default: true

      t.timestamps
    end
  end
end
