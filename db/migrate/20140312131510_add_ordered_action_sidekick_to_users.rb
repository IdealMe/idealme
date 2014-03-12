class AddOrderedActionSidekickToUsers < ActiveRecord::Migration
  def change
    add_column :users, :ordered_action_sidekick, :boolean, default: false
  end
end
