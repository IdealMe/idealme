class CreatePayloads < ActiveRecord::Migration
  def change
    create_table :payloads do |t|
      t.attachment :payload
      t.integer :intended_type
      t.integer :payloadable_id
      t.string :payloadable_type
      t.timestamps
    end
  end
end
