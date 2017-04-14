# All json helpers
module JsonHelper
  def valid_json?(json)
    JSON.parse(json)
    return true
  rescue JSON::ParserError => e
    return false
  end
end
