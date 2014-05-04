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
    def unsupported_type
      halt 415
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

  end

  helpers ResponseHelpers
end
