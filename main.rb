# frozen_string_literal: true

require 'English'
require 'net/http'
require 'json'
require 'erb'

def env_has_key(key)
  value = ENV[key]
  if !value.nil? && value != ''
    value.start_with?('$') ? ENV[value[1..]] : value
  else
    abort("Missing #{key}.")
  end
end

def get_env(key)
  value = ENV[key]
  return unless !value.nil? && value != ''

  value.start_with?('$') ? ENV[value[1..]] : value
end

def create_payload(template, success)
  parsed_json = JSON.parse(template)
  branch_name = get_env('AC_GIT_BRANCH')
  success_message = "<div>✅ Build completed successfully for the branch #{branch_name}</div><br>"
  failed_message = "<div>❌ Build failed for the branch #{branch_name}</div><br>"
  message = success ? success_message : failed_message
  header = "<h1>Appcircle</h1>#{message}"

  parsed_json.each do |json_obj|
    json_obj['value'] = header + json_obj['value'] if json_obj['path'] == '/fields/System.History'
  end
  success_state = get_env('AC_AZUREBOARD_SUCCESS_STATE')
  fail_state = get_env('AC_AZUREBOARD_FAIL_STATE')

  state = success ? success_state : fail_state

  if state
    parsed_json << {
      "op": 'add',
      "path": '/fields/System.State',
      "value": state.to_s
    }
  end
  parsed_json.to_json
end

def patch(payload, endpoint, username, access_key, parse = true)
  uri = URI.parse(endpoint)
  req = Net::HTTP::Patch.new(uri.request_uri,
                             { 'Content-Type' => 'application/json-patch+json' })
  req.body = payload
  req.basic_auth(username, access_key)
  res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
    http.request(req)
  end
  JSON.parse(res.body, symbolize_names: true) if parse
end

azure_host = env_has_key('AC_AZUREBOARD_INSTANCE')
api_version = env_has_key('AC_AZUREBOARD_API_VERSION')
email =  env_has_key('AC_AZUREBOARD_EMAIL')
token =  env_has_key('AC_AZUREBOARD_TOKEN')
organization = env_has_key('AC_AZUREBOARD_ORG')
project = env_has_key('AC_AZUREBOARD_PROJECT')
work_id = env_has_key('AC_AZUREBOARD_WORKITEM')
template = env_has_key('AC_AZUREBOARD_TEMPLATE')
is_success = get_env('AC_IS_SUCCESS')
success = %w[true True].include?(is_success)

payload = create_payload(template, success)
endpoint = "#{azure_host}/#{organization}/#{ERB::Util.url_encode(project.to_s)}/_apis/wit/workitems/#{work_id}?api-version=#{api_version}"
puts "Sending request to: #{endpoint}"
$stdout.flush
result = patch(payload, endpoint, email, token, true)
raise "Request failed #{result[:message]}" if result[:message]

puts "Issue '#{work_id}' updated successfully."
