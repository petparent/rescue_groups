require 'httparty'

class RecordNotFound < StandardError; end

class RemoteClient
  include HTTParty

  debug_output $stdout

  base_uri 'https://api.rescuegroups.org/http/json'
  headers 'Content-Type' => 'application/json'
  default_params apikey: RescueGroups.config.apikey

  class << self
    private

    def post_body(action)
      {
        objectAction: action,
        objectType:   object_type,
      }
    end

    def post_and_respond(post_body)
      response = post(base_uri, { body: JSON(post_body.merge(default_params)) })

      raise RecordNotFound if response.code == 404

      response['data'].map do |key, found_obj|
        attributes = found_obj.nil? ? key : found_obj
        new(attributes)
      end
    end
  end
end
