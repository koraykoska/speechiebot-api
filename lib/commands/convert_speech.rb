module Command
  # The convertspeech command
  class ConvertSpeech < Base
    @command = '/convertspeech'

    def self.can_answer?(json:, bot_name: '')
      message = json['message']
      is_voice = false
      is_voice = !json['message']['voice'].nil? unless message.nil?
      is_voice && !command?(json['message']['text'], bot_name: bot_name)
    end

    def run
      chat = @json['message']['chat']
      chat_id = chat['id']

      reply = @json['message']['reply_to_message']
      # TODO: Make this nicer
      reply = @json['message'] if reply.nil?
      if reply.nil?
        # TODO: Send failure notification

        @result = default_result(ok: false)
        return
      end
      voice = reply['voice']
      if voice.nil?
        text_to_send = 'Please reply to a voice message with this command!'
        chat_to_send = { chat_id: chat_id, text: text_to_send }
        ok = @helpers.send_notification chat: chat_to_send

        @result = default_result(ok: ok)

        # @result = default_result(ok: false)
        return
      end

      # TODO: Error handling!

      file_id = voice['file_id']
      file_json = JSON.parse(@helpers.get_file(file_id: file_id))
      file = @helpers.download_file(path: file_json['result']['file_path'])

      language = @helpers.read_language(chat_id: chat_id)
      speech_response = @helpers.get_text_from_speech(file,
                                                      language_code: language)
      puts speech_response
      results = speech_response['results']
      if results.nil? || results.empty?
        # TODO: Send no assumption notification
        text_to_send = 'Huh!? Is this a sound file? '\
                       'I don\'t have an assumption for that.'
        # reply_to_message = @json['message']['reply_to_message']['message_id']
        reply_to_message = nil
        if !@json['message']['reply_to_message'].nil?
          reply_to_message = @json['message']['reply_to_message']['message_id']
        else
          reply_to_message = @json['message']['message_id']
        end
        chat_to_send = { chat_id: chat_id, text: text_to_send,
                         reply_to_message_id: reply_to_message }
        ok = @helpers.send_notification chat: chat_to_send
        @result = default_result(ok: ok)

        # @result = default_result(ok: false)
        return
      end

      # Send default messages
      message = 'Someone sent a voice message instead of a nice '\
                'text message. Translating it here for you...'
      reply_to_message = @json['message']['message_id']
      chat_to_send = { chat_id: chat_id, text: message,
                       reply_to_message_id: reply_to_message }
      # TODO: We need a configuration for that
      bot = @helpers.settings.bot_username
      unless self.class.can_answer?(json: @json, bot_name: bot)
        @helpers.send_notification chat: chat_to_send
      end

      message = "I have #{results[0]['alternatives'].size} assumptions."
      chat_to_send = { chat_id: chat_id, text: message }
      @helpers.send_notification chat: chat_to_send

      # Send assumptions
      result = results[0]
      result['alternatives'].each do |a|
        transcript = a['transcript']
        confidence = a['confidence']

        message = "#{transcript} (Confidence: #{confidence})"
        reply_to_message = nil
        if !@json['message']['reply_to_message'].nil?
          reply_to_message = @json['message']['reply_to_message']['message_id']
        else
          reply_to_message = @json['message']['message_id']
        end
        chat_to_send = { chat_id: chat_id, text: message,
                         reply_to_message_id: reply_to_message }
        @helpers.send_notification chat: chat_to_send
      end

      @result = default_result(ok: true)
    end
  end
end
