class AddAddedToAweberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :added_to_aweber, :boolean
  end
end
