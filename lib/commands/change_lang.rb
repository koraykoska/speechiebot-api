module Command
  # The convertspeech command
  class ConvertSpeech < Base
    @command = '/changelang'

    def run
      chat = @json['message']['chat']
      chat_id = chat['id']

      text_to_send = 'Pls press one of the buttons to set a default language'\
                     'for your voice messages.'

      # Set up language buttons
      reply_markup = {}

      keyboard = []

      chat_to_send = { chat_id: chat_id, text: text_to_send }

      ok = @helpers.send_notification chat: chat_to_send

      @result = default_result(ok: ok)
    end
  end
end
