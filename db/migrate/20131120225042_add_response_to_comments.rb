class AddResponseToComments < ActiveRecord::Migration
  def change
    add_column :comments, :response, :text
    add_column :comments, :responder_id, :integer
  end
end
