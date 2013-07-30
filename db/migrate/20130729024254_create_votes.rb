class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :votable, :polymorphic => true
      t.boolean :up_vote
      t.boolean :down_vote
      t.integer :owner_id

      t.timestamps
    end
    add_index :votes, :votable_id
  end
end
