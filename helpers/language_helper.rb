# All language helpers
module LanguageHelper
  def available_languages
    langs_file = open(File.expand_path('../data/speech_languages.txt',
                                       File.dirname(__FILE__)))
    langs_file.read.split(',')
  end

  def language_file(chat_id)
    File.expand_path("../db/#{chat_id}_language.json",
                     File.dirname(__FILE__))
  end

  def save_language(language, chat_id:)
    language_hash = { language: language }
    language_json = JSON.generate(language_hash)
    File.open(language_file(chat_id), 'w') { |file| file.write(language_json) }
  end

  def read_language(chat_id:)
    return nil unless File.exist?(language_file(chat_id))

    read = File.read(language_file(chat_id))
    return nil unless valid_json?(read)

    JSON.parse(read)['language']
  end

  def delete_language(chat_id:)
    File.delete(language_file(chat_id))
  end
end
