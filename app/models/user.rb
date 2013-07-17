class User < ActiveRecord::Base
  #Imports
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :token_authenticatable
  #@private
  #Slug
  def to_param
    username
  end

  #Constants

  #Mass Assignments
  attr_accessible :login, :username, :firstname, :lastname, :email, :password, :password_confirmation, :remember_me

  attr_accessor :login
  attr_accessible :login
end
