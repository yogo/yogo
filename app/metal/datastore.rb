# Allow the metal piece to run in isolation
require(File.dirname(__FILE__) + "/../../config/environment") unless defined?(Rails)

class Datastore
  def self.call(env)
    if env["PATH_INFO"] =~ /^\/datastore(.*)/
      if $1.nil? || $1.empty?
        return [303, {'Location' => '/datastore/'}, []]
      else
        env["PATH_INFO"] = $1
      end
      
      rack_request = Rack::Request.new(env)
      @config = YAML.load(File.new(File.join(Rails.root, "config", "database.yml")))

      headers = {}
      env.each { |key, value|
        if key =~ /HTTP_(.*)/
          headers[$1] = value
        end
      }

      result = Net::HTTP.start(@config[Rails.env][:host], @config[Rails.env][:port]) { |http|
        method = rack_request.request_method
        case method
        when "GET", "HEAD", "DELETE", "OPTIONS", "TRACE"
          request = Net::HTTP.const_get(method.capitalize).new(rack_request.fullpath, headers)
        when "PUT", "POST"
          request = Net::HTTP.const_get(method.capitalize).new(rack_request.fullpath, headers)
          request.body_stream = rack_request.body
        else
          raise "method not supported: #{method}"
        end
        http.request(request)
      }

      response_headers = {}
      result.to_hash.each do |key,value|
        response_headers[key] = value.to_s
      end
      # Remove chunked transfer encoding
      response_headers.delete("transfer-encoding") if response_headers['transfer-encoding'] == 'chunked' 
      [result.code, response_headers, [result.body]]
    else
      [404, {'content-type' => 'text/html'}, ["Not the datastore!"]]
    end
  end
end
