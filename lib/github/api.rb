require 'net/http'
require 'json'

class Github::Api
  BASE_URI = 'https://api.github.com'

  def initialize(token)
    @token = token
  end

  def get(path, params = {})
    uri = URI("#{BASE_URI}#{path}")
    uri.query = URI.encode_www_form(params)
    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "Bearer #{@token}"
    request['Accept'] = 'application/vnd.github+json'
    request['User-Agent'] = 'OSS-Trucker'

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    JSON.parse(response.body)
  end
end
