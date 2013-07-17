#Users::PasswordsController
#
#Overloads the default devise password controller
#
#Skips device authorization check
class Users::PasswordsController < Devise::PasswordsController
  skip_authorization_check
end