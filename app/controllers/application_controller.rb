class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_staging
  protected
  def authenticate_staging
    if Rails.env.staging?
      authenticate_or_request_with_http_basic 'Staging' do |name, password|
        name == 'username' && password == 'password'
      end
    end
  end
end
