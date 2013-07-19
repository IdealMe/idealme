class User < ActiveRecord::Base
  # == Imports ==============================================================
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :omniauthable, :token_authenticatable

  # == Slug =================================================================
  def to_param
    username
  end

  # == Constants ============================================================

  # == Attributes ===========================================================
  attr_accessible :login, :username, :firstname, :lastname, :email, :password, :password_confirmation, :remember_me, :avatar,
                  :tagline

  attr_accessor :login
  attr_accessible :login


  # == Relationships ========================================================
  has_many :courses

  # == Paperclip ============================================================
  has_attached_file :avatar,
                    :styles => {:thumb => '40x40#', :square => '120x120#'},
                    :convert_options => {
                        :thumb => '-background black -gravity center -extent 40x40 -quality 75 -strip',
                        :square => '-background black -gravity center -extent 120x120 -quality 75 -strip',
                    }

  # == Validations ==========================================================
  # == Scopes ===============================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Instance Methods =====================================================

  def fullname
    "#{self.firstname} #{self.lastname}"
  end

end
