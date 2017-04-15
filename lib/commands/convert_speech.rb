module Command
  # The convertspeech command
  class ConvertSpeech < Base
    @command = '/convertspeech'

    def run
      chat = @json['message']['chat']
      chat_id = chat['id']

      reply = @json['message']['reply_to_message']
      if reply.nil?
        # TODO: Send failure notification

        @result = default_result(ok: false)
        return
      end
      voice = reply['voice']
      if voice.nil?
        # TODO: Send no voice reply notification

        @result = default_result(ok: false)
        return
      end

      # TODO: Error handling!

      file_id = voice['file_id']
      file_json = JSON.parse(@helpers.get_file(file_id: file_id))
      file = @helpers.download_file(path: file_json['result']['file_path'])

      language = @helpers.read_language(chat_id: chat_id)
      speech_response = @helpers.get_text_from_speech(file,
                                                      language_code: language)
      results = speech_response['results']
      if results.nil? || results.empty?
        # TODO: Send no assumption notification

        @result = default_result(ok: false)
        return
      end

      # Send default messages
      message = 'Oh man I think I spider! The 1 Larry just sent you a voice '\
                'message instead of a naice text message. Here comes the 1 '\
                'translation to rule them all...'
      reply_to_message = @json['message']['message_id']
      chat_to_send = { chat_id: chat_id, text: message,
                       reply_to_message_id: reply_to_message }
      @helpers.send_notification chat: chat_to_send

      message = "I have #{results[0]['alternatives'].size} assumptions."
      chat_to_send = { chat_id: chat_id, text: message }
      @helpers.send_notification chat: chat_to_send

      # Send assumptions
      result = results[0]
      result['alternatives'].each do |a|
        transcript = a['transcript']
        confidence = a['confidence']

        message = "#{transcript} (Confidence: #{confidence})"
        reply_to_message = @json['message']['reply_to_message']['message_id']
        chat_to_send = { chat_id: chat_id, text: message,
                         reply_to_message_id: reply_to_message }
        @helpers.send_notification chat: chat_to_send
      end

      @result = default_result(ok: true)
    end
  end
end
