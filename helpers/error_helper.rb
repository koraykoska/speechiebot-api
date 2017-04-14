# All error helpers
module ErrorHelper
  def json_content_type_header
    { 'Content-Type' => 'application/json' }
  end

  def teapot_code
    418
  end

  def accepted_code
    202
  end

  def teapot_json
    error_hash = { message: 'I am a teapot', error: teapot_code }
    error_string = JSON.generate(error_hash)
    error_string
  end
end
