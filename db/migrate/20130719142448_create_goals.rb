class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.string :name
      t.boolean :hidden, :default => false
      t.boolean :welcome, :default => false
      t.integer :ordering, :default => 9999
      t.integer :user_count
      t.attachment :avatar


      t.references :category

      t.timestamps
    end

    add_index :goals, :category_id

  end
end
