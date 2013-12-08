class AddWelcomeMessageDismissedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :welcome_message_dismissed, :boolean, default: false
  end
end
