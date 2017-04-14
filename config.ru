require 'rubygems'
require 'bundler'

# Load dotenv manually so it is loaded before other gems
# and all the environment variables are already available
require 'dotenv'
Dotenv.load

Bundler.require

# Require standard library gems
require 'base64'
require 'tmpdir'

# require './my_sinatra_app'
require File.expand_path('../app.rb', __FILE__)
use Rack::ShowExceptions
# run MySinatraApp
run SpeechieAPI.new
