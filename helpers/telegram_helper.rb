# encoding: utf-8

# Helpers for telegram requests
module TelegramHelper
  # rubocop:disable MethodLength
  def send_notification(chat:)
    return false if chat.nil?

    url = "https://api.telegram.org/bot#{settings.telegram_token}/sendMessage"

    request = Typhoeus::Request.new(
      url,
      method: :post,
      body: JSON.generate(chat),
      headers: json_content_type_header
    )
    request.run

    response = request.response
    code = response.code
    # time = response.total_time
    # headers = response.headers
    body = response.body

    puts body

    code >= 200 && code < 300
  end

  def get_file(file_id:)
    return nil if file_id.nil?

    url = "https://api.telegram.org/bot#{settings.telegram_token}/getFile"
    body = { file_id: file_id }

    request = Typhoeus::Request.new(
      url,
      method: :post,
      body: JSON.generate(body),
      headers: json_content_type_header
    )
    request.run

    request.response.body
  end

  def download_file(path:)
    return nil if path.nil?

    url = "https://api.telegram.org/file/bot#{settings.telegram_token}/#{path}"

    request = Typhoeus::Request.new(
      url,
      method: :get
    )
    request.run

    request.response.body
  end
end
