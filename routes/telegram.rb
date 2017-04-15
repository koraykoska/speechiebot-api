# The main class for all telegram api requests
class SpeechieAPI < Sinatra::Base
  set :token, settings.telegram_token

  post "/#{token}/?" do
    request.body.rewind
    payload_body = request.body.read

    puts payload_body

    unless valid_json?(payload_body)
      return halt teapot_code, json_content_type_header,
                  teapot_json
    end

    payload = JSON.parse(payload_body)

    results = []

    get_commands(json: payload).each do |c|
      c.run
      results << c.result
    end

    string_results = JSON.generate(results)
    return halt accepted_code, json_content_type_header, string_results
  end
end
