module Command
  # The changelang command
  class ChangeLang < Base
    @command = '/changelang'

    def self.context?(text)
      text == @command
    end

    def run
      if @context
        context_run
        return
      end

      chat = @json['message']['chat']
      chat_id = chat['id']

      text_to_send = 'Please press one of the buttons to set a default '\
                     'language for your voice messages.'

      # Set up language buttons
      reply_markup = {}
      keyboard = []

      langs = @helpers.available_languages
      langs.each do |l|
        keyboard << [l]
      end

      reply_markup[:keyboard] = keyboard

      chat_to_send = { chat_id: chat_id, text: text_to_send,
                       reply_markup: reply_markup }

      # Save context file
      @helpers.save_context(self.class.command, chat_id: chat_id)

      ok = @helpers.send_notification chat: chat_to_send

      @result = default_result(ok: ok)
    end

    def context_run
      chat = @json['message']['chat']
      chat_id = chat['id']
      text = @json['message']['text']

      # Check language
      langs = @helpers.available_languages
      unless langs.include?(text)
        text_to_send = "Huh!? I am afraid I can't speak #{text}"
        chat_to_send = { chat_id: chat_id, text: text_to_send }
        ok = @helpers.send_notification chat: chat_to_send
        @result = default_result(ok: ok)
        return
      end

      # Save language file
      @helpers.save_language(text, chat_id: chat_id)

      # Delete context file
      @helpers.delete_context(chat_id: chat_id)

      text_to_send = "OK! The default language #{text} was set!"
      reply_markup = { remove_keyboard: true }
      chat_to_send = { chat_id: chat_id, text: text_to_send,
                       reply_markup: reply_markup }
      ok = @helpers.send_notification chat: chat_to_send
      @result = default_result(ok: ok)
    end
  end
end
