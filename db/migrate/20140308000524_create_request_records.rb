class CreateRequestRecords < ActiveRecord::Migration
  def change
    create_table :request_records do |t|
      t.string :session_id
      t.integer :user_id
      t.string :request_method
      t.float :request_duration
      t.text :fullpath
      t.string :conversion

      t.timestamps
    end
  end
end
