module Sinatra
  module ResponseHelpers
    # Internal: Handle bad responses
    #
    # Returns nothing
    # Halts with a 400
    def bad_request
      halt 400, params.to_json
    end

    # Internal: Helper for unsupported media types
    #
    # Returns nothing
    # Halts with a 415
    def unsupported_type
      halt 415
    end

    def send_image(img, format)
      content_type MIME_TYPES[format]
      img
    end

    private

    MIME_TYPES = {
      'png' => 'image/png',
      'gif' => 'image/gif',
      'jpg' => 'image/jpeg',
      'svg' => 'image/svg+xml'
    }

  end

  helpers ResponseHelpers
end
