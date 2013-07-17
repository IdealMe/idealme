class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|

      t.boolean :has_password, :default => true
      t.datetime :identity_unlocked_at, :null => false, :default => Time.zone.local(1970, 1, 1, 1, 1)
      t.text :about
      t.text :notes
      t.string :firstname
      t.string :lastname
      t.string :username
      t.string :timezone, :default => 'Etc/Zulu'
      t.decimal :survey_base, :precision => 6, :scale => 3, :default => 0
      t.decimal :checkin_base, :precision => 6, :scale => 3, :default => 0
      t.boolean :auto_follow, :default => false
      t.string :affiliate_tag
      t.integer :affiliate_default_payment_id
      t.integer :affiliate_payment_frequency
      t.boolean :access_normal, :default => true
      t.boolean :access_affiliate, :default => false
      t.boolean :access_course_creation, :default => false
      t.boolean :access_support, :default => false
      t.boolean :access_administrator_read_only, :default => false
      t.boolean :access_administrator, :default => false
      t.attachment :profile_pic

      ## Database authenticatable
      t.string :email, :null => false, :default => ""
      t.string :encrypted_password, :null => false, :default => ""

      ## Recoverable
      t.string :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, :default => 0 # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      ## Token authenticatable
      t.string :authentication_token

      t.integer :goal_count, :default => 0
      t.integer :course_count, :default => 0


      t.timestamps
    end

    add_index :users, :email, :unique => true
    add_index :users, :reset_password_token, :unique => true
    # add_index :users, :confirmation_token,   :unique => true
    # add_index :users, :unlock_token,         :unique => true
    # add_index :users, :authentication_token, :unique => true
  end
end