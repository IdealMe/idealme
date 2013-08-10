source 'https://rubygems.org'

#MetaInspector lets you scrape a web page and get its title, charset, link and meta tags
gem 'metainspector'
#Active Merchant is a simple payment abstraction library used in and sponsored by Shopify.
gem 'activemerchant'
#Create JSON structures via a Builder-style DSL
gem 'jbuilder'
#
gem 'rabl'
#BestInPlace is a jQuery script and a Rails 3 helper that provide the method best_in_place to display any object field easily editable for the user by just clicking on it. 
gem 'best_in_place'

gem 'ransack'

#Ruby on Rails
gem 'rails', :git => 'git://github.com/rails/rails.git', :branch => '3-2-stable'
#This module allows Ruby programs to interface with the SQLite3 database engine
gem 'sqlite3'
#A simple, fast Mysql library for Ruby, binding to libmysql
gem 'mysql2'
#A thin and fast web server
gem 'thin'
#Pg is the Ruby interface to the PostgreSQL RDBMS. It works with PostgreSQL 8.4 and later
gem 'pg'
#Flexible authentication solution for Rails with Warden
gem 'devise'
#Simple authorization solution for Rails which is decoupled from user roles. All permissions are stored in a single location.
gem 'cancan'
#Capistrano is a utility and framework for executing commands in parallel on multiple remote machines, via SSH.
gem 'capistrano'
#A generalized Rack framework for multiple-provider authentication.
gem 'omniauth'
#Facebook strategy for OmniAuth
gem 'omniauth-facebook'
#A Google oauth2 strategy for OmniAuth 1.0
gem 'omniauth-google-oauth2'
#OmniAuth strategy for Twitter
gem 'omniauth-twitter'

#Send your application errors to our hosted service and reclaim your inbox.
gem 'airbrake'
#If you need to send some data to your js files and you don't want to do this with long way trough views and parsing - use this force!
gem 'gon'
#Easy upload management for ActiveRecord
gem 'paperclip', '~> 3.4.2'
#Extends Rails seeds to split out complex seeds into multiple files and lets each environment have it's own seeds.
gem 'seedbank', :github => 'james2m/seedbank'
#A Rails form builder that generates Twitter Bootstrap markup and helps keep your code clean
gem 'formatted_form'
#ComfortableMexicanSofa is a powerful CMS Engine for Ruby on Rails applications
gem 'comfortable_mexican_sofa', '~> 1.8.0'
#FriendlyId is the "Swiss Army bulldozer" of slugging and permalink plugins for Ruby on Rails. It allows you to create pretty URLs and work with human-friendly strings as if they were numeric ids for Active Record models.
gem 'friendly_id'
#Seamlessly integrates TinyMCE into the Rails asset pipeline introduced in Rails 3.1.
gem 'tinymce-rails'
#This gem provides jQuery and the jQuery-ujs driver for your Rails 3 application.
gem 'jquery-rails'
#Search Engine Optimization (SEO) plugin for Ruby on Rails applications.
gem 'meta-tags', :require => 'meta_tags'
#Great Ruby dubugging companion: pretty print Ruby objects to visualize their structure. Supports custom object formatting via plugins
gem 'awesome_print'
#AWS SDK for Ruby
gem 'aws-sdk'
#Do some browser detection with Ruby.
gem 'browser'
#TZInfo is a Ruby library that uses the standard tz (Olson) database to provide daylight savings aware transformations between times in different time zones.
gem 'tzinfo'
#will_paginate provides a simple API for performing paginated queries with Active Record, DataMapper and Sequel, and includes helpers for rendering pagination links in Rails, Sinatra and Merb web apps.
gem 'will_paginate'
#Extends the functionality of ActiveRecord::Base#clone to perform a deep clone that includes user specified associations.
gem 'deep_cloneable'
#New Relic is a performance management system, developed by New Relic, Inc (http://www.newrelic.com). New Relic provides you with deep information about the performance of your web application as it runs in production. The New Relic Ruby Agent is dual-purposed as a either a Gem or plugin, hosted on http://github.com/newrelic/rpm/
gem 'newrelic_rpm'
#A gem to sign url and stream paths for Amazon CloudFront private content. Includes specific signing methods for both url and streaming paths, including html 'safe' escpaed versions of each.
gem 'cloudfront-signer'


gem 'twitter'
gem 'database_cleaner'


group :assets do
  gem 'coffee-rails', '~> 3.2.1'
  gem 'haml-rails'
  gem 'therubyracer'
  gem 'less-rails'
  gem 'twitter-bootstrap-rails'
  #Sass adapter for the Rails asset pipeline.
  gem 'sass-rails', '~> 3.2.6'
  #Ruby wrapper for UglifyJS JavaScript compressor
  gem 'uglifier', '>= 1.3.0'
  #jQuery UI's JavaScript, CSS, and image files packaged for the Rails 3.1+ asset pipeline
  gem 'jquery-ui-rails'
  #Integrate Compass into Rails 2.3 and up.
  gem 'compass-rails'
  gem 'font-awesome-rails'
end

group :test do
  gem 'simplecov', :require => false
end

group :development do
  gem 'capistrano-unicorn', :require => false
  gem 'capistrano-maintenance'
  
  gem 'quiet_assets'
  #A rails plugin to kill N+1 queries and unused eager loading.
  gem 'bullet'
  #Automatically generate an entity-relationship diagram (ERD) for your Rails models.
  gem 'rails-erd'
  #Provides a better error page for Rails and other Rack apps. Includes source code inspection, a live REPL and local/instance variable inspection for all stack frames.
  gem 'better_errors'
  #Retrieve the binding of a method's caller. Can also retrieve bindings even further up the stack.
  gem 'binding_of_caller'
  #Request your request
  gem 'meta_request'
  #Brakeman detects security vulnerabilities in Ruby on Rails applications via static analysis.
  gem 'brakeman'
  #a code metric tool for rails codes, written in Ruby.
  gem 'rails_best_practices'
  #Fails your build if code quality thresholds are not met
  gem 'cane'
  #Reek is a tool that examines Ruby classes, modules and methods and reports any code smells it finds.
  gem 'reek'
end


group :development, :test do
  gem 'rspec-rails', '2.14.0'
  gem 'factory_girl'
  gem 'factory_girl_rails'
end

group :production, :staging do
  gem 'unicorn'
end