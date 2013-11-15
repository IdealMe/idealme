class AddDropboxPathToPayload < ActiveRecord::Migration
  def change
    add_column :payloads, :dropbox_path, :string
  end
end
