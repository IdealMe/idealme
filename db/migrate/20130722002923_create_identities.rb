class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.text :access_token
      t.string :uid
      t.string :provider
      t.string :identifier
      t.integer :owner_id

      t.timestamps
    end
    add_index :identities, :owner_id
  end
end
