module Command
  # The convertspeech command
  class ConvertSpeech < Base
    @command = '/convertspeech'

    def run
      chat = @json['message']['chat']

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
      file_json = JSON.parse(get_file(file_id: file_id))
      file = download_file(path: file_json['result']['file_path'])
    end
  end
end
