# All context helpers
module ContextHelper
  def context_file(chat_id)
    File.expand_path("../db/#{chat_id}_context.json",
                     File.dirname(__FILE__))
  end

  def save_context(context, chat_id:)
    context_hash = { context: context }
    context_json = JSON.generate(context_hash)
    File.open(context_file(chat_id), 'w') { |file| file.write(context_json) }
  end

  def read_context(chat_id:)
    return nil unless File.exist?(context_file(chat_id))

    read = File.read(context_file(chat_id))
    return nil unless valid_json?(read)

    JSON.parse(read)['context']
  end

  def delete_context(chat_id:)
    File.delete(context_file(chat_id))
  end
end
