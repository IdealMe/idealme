#!/usr/bin/env ruby
require "rubygems"
require "bundler/setup"
require 'mailman'
require 'pry'


Mailman.config.logger = Logger.new("log/mailman.log")

Mailman.config.pop3 = {
  server: 'pop.gmail.com', port: 995, ssl: true,
  username: ENV["QUESTIONS_EMAIL_USERNAME"],
  password: ENV["QUESTIONS_EMAIL_PASSWORD"]
}

Mailman::Application.run do
  to('questions+%user_id%-%course_id%@idealme.com') do |user_id, course_id|
    #ap User.find user_id
    #ap Course.find course_id
    ap message.text_part.to_s.split("\r\n\r\n")
  end

  default do
    ap message.to
  end
end

