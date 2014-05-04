module Sinatra
  module RequestHelpers

    FORMATS = %w(svg png gif jpg)

    # Internal: The requested barcode encoding
    #
    # Returns a String
    def encoding
      params['encoding'].downcase
    end

    # Internal: The value to encode
    #
    # Returns a String
    def data 
      params['data']
    end

    # Internal: Helper to retrieve the barcode response format
    #
    # Returns a String
    def format
      params['format'].downcase
    end

    # Internal: Requires that the encoding and format be supported
    #
    # Returns nothing
    # Halts with a 415
    def supported!
      unless FORMATS.include?(format) && BarcodeFactory.supported?(encoding)
        unsupported_type
      end
    end

    # Internal: Ensures all required fields are present
    #
    # Returns nothing
    # Halts with a 400
    REQUIRED_PARAMS = %w(format encoding data)

    def valid_request!
      bad_request if REQUIRED_PARAMS.any? { |f| f.nil? }
    end
  end

  helpers RequestHelpers
end

