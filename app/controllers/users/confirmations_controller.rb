#Users::ConfirmationsController
#
#Overloads the default devise confirmations controller
#
#Skips device authorization check
class Users::ConfirmationsController < Devise::ConfirmationsController
  skip_authorization_check
end