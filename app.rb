# The main class for the kw-api
class SpeechieAPI < Sinatra::Base
  enable :sessions

  configure :production do
    set :haml, ugly: true
    set :clean_trace, true
  end

  configure :development do
    # ...
  end

  configure do
    # Datamapper timezone workaround
    ENV['TZ'] = 'utc'

    set :telegram_token, ENV['TELEGRAM_TOKEN']
    set :bot_username, ENV['BOT_USERNAME']
    set :google_speech_api_key, ENV['GOOGLE_SPEECH_API_KEY']
  end

  helpers do
    include Rack::Utils
    alias_method :h, :escape_html
  end
end

# Load helpers first so they are available even to lib
require_relative 'helpers/init'
# lib should be required first so it is available as soon as possible
require_relative 'lib/init'
require_relative 'models/init'
require_relative 'routes/init'
