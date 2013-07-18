class CreateMarkets < ActiveRecord::Migration
  def change
    create_table :markets do |t|
      t.string :name
      t.string :slug
      t.boolean :hidden
      t.attachment :avatar

      t.timestamps
    end
  end
end
