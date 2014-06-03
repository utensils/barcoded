module Sinatra
  module ResponseHelpers
    # Internal: Handle bad responses
    #
    # Returns nothing
    # Halts with a 400
    def bad_request(error = nil)
      params['error'] = error if error
      do_halt 400, params
    end

    # Internal: Helper for unsupported media types
    #
    # Returns nothing
    # Halts with a 415
    def unsupported_type(error)
      params['error'] = error
      do_halt 415, params
    end

    # Internal: Handle response for new events
    #
    # Returns Event as JSON or XML
    def created
      headers location
      status 201
      data = params.merge(location)
      respond_to do |format|
        format.json { data.to_json }
        format.xml { data.to_xml(root: :barcode, skip_types: true) }
      end
    end

    # Internal: Helper for rendering a String as an image
    #
    # img    - An image as a String
    # format - The expected format (eg. :png)
    #
    # Returns a String
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

    # Internal: A helper for halting
    #
    # Returns a Response with a code and body
    def do_halt(code, body)
      respond_to do |format|
        format.json { halt code, body.to_json }
        format.xml { halt code, body.to_xml(root: :barcode, skip_types: true) }
      end
    end

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
      query = URI.encode_www_form(options)
      URI.escape("#{current_host}/img/#{encoding}/#{data}.#{format}?#{query}")
    end

    # Internal: Build a String for the current host
    #
    # Returns a String
    def current_host
      port = ":#{request.port}" unless request.port == 80
      "http://#{request.host}#{port}"
    end

    # Internal: Is CORS enabled or not
    #
    # Returns a Boolean
    def cors_enabled?
      ENV['RACK_CORS'] == 'enabled'
    end

    # Internal: Allow cross origin request/responses
    #
    # Returns nothing
    def allow_cross_origin
      cross_origin  allow_origin:   ENV['RACK_CORS_ORIGINS'],
                    allow_methods:  %i(post options get)
    end
  end

  helpers ResponseHelpers
end
