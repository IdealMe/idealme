source 'https://rubygems.org'

gem 'nokogiri'

#Ruby on Rails
gem 'rails', '~> 3.2.15'

gem 'json', '~> 1.8.1'
gem 'bluepill'

# A library for working with SendGrid's Newsletter API. The code is intended for managing and sending newletters.
gem 'gatling_gun'

# An ActiveRecord plugin for managing lists. http://swanandp.github.io/acts_as_list/
gem 'acts_as_list'

# chatty chat chat.
gem 'hipchat'

# error notifications
gem 'honeybadger'

#A thin and fast web server
gem 'thin'

gem 'puma'

#Pg is the Ruby interface to the PostgreSQL RDBMS. It works with PostgreSQL 8.4 and later
gem 'pg'

gem 'redis'
gem 'sidekiq'

#Flexible authentication solution for Rails with Warden
gem 'devise'

#Simple authorization solution for Rails which is decoupled from user roles. All permissions are stored in a single location.
gem 'cancan'

#Capistrano is a utility and framework for executing commands in parallel on multiple remote machines, via SSH.
gem 'recap'
#gem 'capistrano', '~> 2.0.0'
#gem 'capistrano-rails'
#gem 'capistrano-rvm', '~> 0.0.2'
#gem 'capistrano-bundler'

#A generalized Rack framework for multiple-provider authentication.
gem 'omniauth'

#Facebook strategy for OmniAuth
gem 'omniauth-facebook'

#A Google oauth2 strategy for OmniAuth 1.0
gem 'omniauth-google-oauth2'

#Twitter strategy for OmniAuth
gem 'omniauth-twitter'

#If you need to send some data to your js files and you don't want to do this with long way trough views and parsing - use this force!
gem 'gon'

#Easy upload management for ActiveRecord
gem 'paperclip', '~> 3.4.2'

#A Rails form builder that generates Twitter Bootstrap markup and helps keep your code clean
gem 'formatted_form'

gem 'simple_form'

#ComfortableMexicanSofa is a powerful CMS Engine for Ruby on Rails applications
gem 'comfortable_mexican_sofa', '~> 1.8.0'

#FriendlyId is the "Swiss Army bulldozer" of slugging and permalink plugins for Ruby on Rails. It allows you to create pretty URLs and work with human-friendly strings as if they were numeric ids for Active Record models.
gem 'friendly_id', '~> 4.0.10'

#Seamlessly integrates TinyMCE into the Rails asset pipeline introduced in Rails 3.1.
gem 'tinymce-rails'

#This gem provides jQuery and the jQuery-ujs driver for your Rails 3 application.
gem 'jquery-rails'

# Search Engine Optimization (SEO) plugin for Ruby on Rails applications.
gem 'meta-tags', :require => 'meta_tags'


gem 'pry-rails'
gem 'pry-nav'
gem 'pry-remote'
gem 'awesome_print'

#A collection of geographic country and state names for Ruby. Also includes replacements for Rails' country_select and state_select plugins
gem 'carmen'
#Provides country_select and subregion_select form helpers.
gem 'carmen-rails'

#AWS SDK for Ruby
gem 'aws-sdk'

#Do some browser detection with Ruby.
gem 'browser'

#TZInfo is a Ruby library that uses the standard tz (Olson) database to provide daylight savings aware transformations between times in different time zones.
gem 'tzinfo'

#will_paginate provides a simple API for performing paginated queries with Active Record, DataMapper and Sequel, and includes helpers for rendering pagination links in Rails, Sinatra and Merb web apps.
gem 'will_paginate'

#Extends the functionality of ActiveRecord::Base
#clone to perform a deep clone that includes user specified associations.
gem 'deep_cloneable'

# New Relic is a performance management system, developed by New Relic, Inc (http://www.newrelic.com). New Relic provides you with deep information about the performance of your web application as it runs in production. The New Relic Ruby Agent is dual-purposed as a either a Gem or plugin, hosted on http://github.com/newrelic/rpm/
# gem 'newrelic_rpm'

#A gem to sign url and stream paths for Amazon CloudFront private content. Includes specific signing methods for both url and streaming paths, including html 'safe' escpaed versions of each.
gem 'cloudfront-signer'

#MetaInspector lets you scrape a web page and get its title, charset, link and meta tags
gem 'metainspector'

#Active Merchant is a simple payment abstraction library used in and sponsored by Shopify.
gem 'activemerchant'

#Create JSON structures via a Builder-style DSL
gem 'jbuilder'

#General ruby templating with json, bson, xml and msgpack support
gem 'rabl'

#BestInPlace is a jQuery script and a Rails 3 helper that provide the method best_in_place to display any object field easily editable for the user by just clicking on it.
gem 'best_in_place'

#Ransack is the successor to the MetaSearch gem. It improves and expands upon MetaSearch's functionality, but does not have a 100%-compatible API.
gem 'ransack'

#A Ruby interface to the Twitter API.
gem 'twitter'

# network libs
gem 'faraday'
gem 'typhoeus'

gem 'slim'
gem 'haml2slim'
group :assets do
  gem 'coffee-rails', '~> 3.2.1'
  #gem 'haml-rails'
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
  # gem 'turbo-sprockets-rails3', git: 'https://github.com/spohlenz/turbo-sprockets-rails3.git'
end

gem 'stripe'

#Simple Rails app configuration
gem 'figaro'

gem 'taps-taps'

group :test do
  #gem 'simplecov', :require => false
  gem 'poltergeist'
  gem 'vcr'
end

group :development do
  gem 'quiet_assets'

  #A rails plugin to kill N+1 queries and unused eager loading.
  gem 'bullet'

  gem 'rack-mini-profiler'

  #Automatically generate an entity-relationship diagram (ERD) for your Rails models.
  gem 'rails-erd'

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

  # gem 'guard-rails'
  gem 'guard-bundler'
  gem 'guard-rspec'
  gem 'guard-livereload'
  # gem 'guard-rubocop'
  gem 'rack-livereload'
end

group :development, :test do
  gem 'rspec-rails', '2.14.0'
  gem 'factory_girl'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'launchy'
  gem 'selenium-webdriver'

  #Strategies for cleaning databases. Can be used to ensure a clean state for testing.
  gem 'database_cleaner'
end

group :production, :staging do
  gem 'unicorn'
end
