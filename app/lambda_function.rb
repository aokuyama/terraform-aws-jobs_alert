require 'uri'
require 'net/http'
require 'json'

def lambda_handler(event:, context:)
  uri = URI.parse(ENV['SLACK_HOOK_URL'])
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  req = Net::HTTP::Post.new(uri.path, initheader = { 'Content-Type' => 'application/json' })
  req.body = { "attachments": [{ "text" => "test" }] }.to_json
  res = http.request(req)
end
