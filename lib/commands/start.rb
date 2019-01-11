module Command
  # The start command
  class Start < Base
    @command = '/start'

    def run
      chat = @json['message']['chat']
      chat_id = chat['id']
      chat_title = chat['title']
      chat_first_name = chat['first_name']

      chat_name = '1 Larry'
      if !chat_title.nil?
        chat_name = chat_title
      elsif !chat_first_name.nil?
        chat_name = chat_first_name
      end

      text_to_send = "Hi #{chat_name}! Welcome to Speechie, your friendly "
      text_to_send += 'voice message bot. Please feel free and reply to a '
      text_to_send += 'voice message with the command /convertspeech so we '
      text_to_send += 'can translate it to text for you!'

      chat_to_send = { chat_id: chat_id, text: text_to_send }

      ok = @helpers.send_notification chat: chat_to_send

      @result = default_result(ok: ok)
    end
  end
end
