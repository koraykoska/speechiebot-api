# encoding: utf-8

# Helpers for the Google speech API
module SpeechApiHelper
  # rubocop:disable MethodLength, Metrics/AbcSize
  def get_text_from_speech(bytes, language_code: nil)
    return nil if bytes.nil?

    temp = Dir.tmpdir.to_s
    random_name = UUIDTools::UUID.random_create.to_s

    # Write ogg file to tmp directory
    ogg_file = File.join(temp, "#{random_name}.ogg")
    File.open(ogg_file, 'w') { |file| file.write(bytes) }

    # Write flac file to tmp directory
    flac_file = File.join(temp, "#{random_name}.flac")
    system "opusdec --force-wav #{ogg_file} - | sox - #{flac_file}"

    # Delete ogg file from tmp directory
    File.delete(ogg_file)
    ogg_file = nil

    # Start request building
    request = {}

    request_config = {}
    request_config[:encoding] = 'FLAC'
    # request_config[:sampleRate] = 16_000
    request_config[:languageCode] = language_code unless language_code.nil?

    request[:config] = request_config

    # Strict encode base64 so we don't have newlines
    flac_base64 = Base64.strict_encode64(File.read(flac_file))

    # Delete flac file from tmp directory
    File.delete(flac_file)
    flac_file = nil

    request_audio = { content: flac_base64 }

    request[:audio] = request_audio

    # Build request
    url = 'https://speech.googleapis.com/v1beta1/speech:syncrecognize?key='\
          "#{settings.google_speech_api_key}"

    request = Typhoeus::Request.new(
      url,
      method: :post,
      body: JSON.generate(request),
      headers: json_content_type_header
    )
    request.run

    JSON.parse(request.response.body)
  end
end
