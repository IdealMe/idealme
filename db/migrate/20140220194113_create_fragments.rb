class CreateFragments < ActiveRecord::Migration
  def change
    create_table :fragments do |t|
      t.string :name
      t.string :description
      t.string :slug
      t.text :html

      t.timestamps
    end
  end
end
