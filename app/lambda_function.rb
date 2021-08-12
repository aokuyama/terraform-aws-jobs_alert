require 'uri'
require 'net/http'

def get_color(status)
  colors = 
  {
    "SUCCEEDED" => "good",
    "FAILED" => "danger",
  }
  colors[status] || "warning"
end

def get_jobs_url(region, id)
  "https://" + region + ".console.aws.amazon.com/batch/home?region=" + region + "#jobs/detail/" + id
end

def lambda_handler(event:, context:)
  region = event["region"]
  detail = event["detail"]
  id = detail["jobId"]
  status = detail["status"]
  job_name = detail["jobName"]
  reason = detail["statusReason"]
  queue = detail["jobQueue"]
  definition = detail["jobDefinition"]
  fields = [
    {
        "title" => "Definition",
        "value" => definition,
        "short" => "true",
    },
    {
        "title" => "Queue",
        "value" => queue,
        "short" => "true",
    }
  ]

  attachments = [
    {
      "color" => get_color(status),
      "title" => job_name,
      "title_link" => get_jobs_url(region, id),
      "text" => "*" + status + "*" + "\n" + reason,
      "fields" => fields,
      "footer" => id,
    }
  ]

  uri = URI.parse(ENV['SLACK_HOOK_URL'])
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  req = Net::HTTP::Post.new(uri.path, initheader = { 'Content-Type' => 'application/json' })
  req.body = { "attachments" => attachments }.to_json
  res = http.request(req)
end
