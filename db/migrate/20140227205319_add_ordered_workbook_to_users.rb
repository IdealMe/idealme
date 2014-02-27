class AddOrderedWorkbookToUsers < ActiveRecord::Migration
  def change
    add_column :users, :ordered_workbook, :boolean, default: false
  end
end
