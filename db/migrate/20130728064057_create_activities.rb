class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.boolean :read, :default => false
      t.integer :count, :default => 1
      t.string :key
      t.string :action
      t.text :parameters
      t.references :sender, :polymorphic => true
      t.references :trackable, :polymorphic => true

      t.timestamps
    end
  end
end
