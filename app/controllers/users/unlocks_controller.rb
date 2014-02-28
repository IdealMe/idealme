class Users::UnlocksController < Devise::UnlocksController
  skip_authorization_check
end
