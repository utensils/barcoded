module Sinatra
  module ResponseHelpers
    # Internal: Handle bad responses
    #
    # Returns nothing
    # Halts with a 400
    def bad_request(error = nil)
      params['error'] = error if error
      halt 400, params.to_json
    end

    # Internal: Helper for unsupported media types
    #
    # Returns nothing
    # Halts with a 415
    def unsupported_type(error)
      params['error'] = error
      halt 415, params.to_json
    end

    # Internal: Handle response for new events
    #
    # barcode - the Barcode that was created
    #
    # Returns Event as JSON
    def created(barcode)
      content_type 'application/json'
      headers location 
      status 201
      params.merge(location).to_json
    end

    def send_image(img, format)
      content_type format.to_sym
      img
    end

    # Internal: Helper for basic health check
    #
    # Returns a String of 'pong'
    def healthy_response
      content_type 'text/plain'
      status 200
      'pong'
    end

    # Internal: Handle response to list symbologies
    #
    # Returns an Array of supported symbologies in JSON
    def symbologies
      content_type 'application/json'
      status 200
      encodings = BarcodeFactory.supported_encodings.map { |symbology| {:symbology => symbology}}
      encodings.to_json
    end


    private
    
    # Internal: A helper for a location Hash
    #
    # Returns a Hash with `location` key
    def location
      { 'location' => resource_link }
    end
    
    # Internal: Build a resource link based on the requested data 
    #
    # Returns a String
    def resource_link
      "/img/#{encoding}/#{data}.#{format}"
    end

    MIME_TYPES = {
      'png' => 'image/png',
      'gif' => 'image/gif',
      'jpg' => 'image/jpeg',
      'svg' => 'image/svg+xml'
    }

  end

  helpers ResponseHelpers
end
