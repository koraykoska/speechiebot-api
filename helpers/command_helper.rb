# encoding: utf-8

# Helpers for the telegram bot commands
module CommandHelper
  def get_commands(json:)
    commands = [Command::Start, Command::ConvertSpeech, Command::ChangeLang]

    command = json['message']['text']

    correct_commands = []
    commands.each do |c|
      if c.command?(command, bot_name: settings.bot_username)
        correct_commands << c.new(json: json, helpers: self)
      end
    end

    # Get context, if any and set context commands
    context = read_context(chat_id: json['message']['chat']['id'])
    unless context.nil?
      commands.each do |c|
        next unless c.context?(context)
        comm = c.new(json: json, helpers: self)
        comm.context = true
        correct_commands << comm
      end
    end

    correct_commands
  end
end
