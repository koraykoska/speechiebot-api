# encoding: utf-8
require_relative 'json_helper'
SpeechieAPI.helpers JsonHelper

require_relative 'error_helper'
SpeechieAPI.helpers ErrorHelper

require_relative 'command_helper'
SpeechieAPI.helpers CommandHelper

require_relative 'telegram_helper'
SpeechieAPI.helpers TelegramHelper
