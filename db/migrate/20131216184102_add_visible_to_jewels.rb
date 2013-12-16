class AddVisibleToJewels < ActiveRecord::Migration
  def change
    add_column :jewels, :visible, :boolean, deafult: false
  end
end
