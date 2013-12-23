class CreateSavedJewel < ActiveRecord::Migration
  def change
    create_table :saved_jewels do |t|
      t.references :jewel
      t.references :user
      t.timestamps
    end
  end
end
