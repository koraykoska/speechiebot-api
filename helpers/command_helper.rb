# encoding: utf-8

# Helpers for the telegram bot commands
module CommandHelper
  def get_commands(json:)
    commands = [Command::Start, Command::ConvertSpeech]

    command = json['message']['text']

    correct_commands = []
    commands.each do |c|
      if c.command?(command, bot_name: settings.bot_username)
        correct_commands << c.new(json: json, helpers: self)
      end
    end

    correct_commands
  end
end
